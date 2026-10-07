using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using _241611JalopEventsManagement.Backend.Models;
using _241611JalopEventsManagement.Backend.Repository;

public static class SystemAudit
{
    static EventRepository events = new EventRepository();
    static RegistrationRepository registrations = new RegistrationRepository();
    static int passes, findings;
    static object Sql(string sql) { return DatabaseConnection.ExecuteScalar(sql); }
    static void Check(bool condition, string name) {
        if (condition) { passes++; Console.WriteLine("PASS: " + name); }
        else { findings++; Console.WriteLine("FINDING: " + name); }
    }
    static EventModel NewEvent(string name, int capacity = 10) {
        return new EventModel { Title = "Audit " + name, VenueLocation = "Disposable test room", MaxCapacity = capacity,
            CreatedByUserId = 1, EventStart = DateTime.Now.Date.AddDays(7).AddHours(9),
            EventEnd = DateTime.Now.Date.AddDays(7).AddHours(17), RegStart = DateTime.Now.AddDays(-1),
            RegEnd = DateTime.Now.AddDays(2), Status = "Upcoming" };
    }
    static int Create(string name, int capacity = 10) { return events.CreateEvent(NewEvent(name, capacity)); }
    static EventRegistrationModel Ticket(int eventId, string student = "AUDIT-IT", int year = 2, string section = "AUDIT") {
        return new EventRegistrationModel { EventId = eventId, StudentId = student, CurrentYearLvl = year, CurrentSection = section };
    }
    static void Audience(string name, string branch, string dept, string program, int? year, bool matches, bool browse = true) {
        var ev = NewEvent(name); ev.TargetBranch = branch; ev.TargetDepartment = dept; ev.TargetProgram = program; ev.TargetYearLevel = year;
        int id = events.CreateEvent(ev);
        bool shown = events.GetEventsForStudent("San Bartolome (Main)", "College of Computer Studies", "BS Information Technology", null).Any(e => e.EventId == id);
        Check(shown == (matches || (browse && year.HasValue && branch == null && dept == null && program == null)), name + " catalog visibility");
        string reason = events.GetRegistrationUnavailableReason(id, "AUDIT-IT", 2);
        Check((reason == "") == matches, name + " direct-link eligibility");
        int result = registrations.RegisterStudent(Ticket(id));
        Check(matches ? result > 0 : result == -3, name + " atomic booking eligibility");
    }
    public static int Main() {
        // Never permit this executable to run against the user's application database.
        using (var connection = DatabaseConnection.GetOpenConnection()) {
            if (!connection.Database.StartsWith("JalopAudit_", StringComparison.Ordinal)) throw new InvalidOperationException("Audit requires a disposable database.");
        }
        Sql(@"INSERT INTO dbo.UserTable (Email,PasswordHash,PasswordSalt,Role) VALUES ('admin@audit.invalid','test','test','Admin'), ('student@audit.invalid','test','test','Student');
              INSERT INTO dbo.StudentTable (StudentId,FirstName,LastName,Gender,CampusBranch,Department,Program,UserId) VALUES
              ('AUDIT-IT','Test','IT','Other','San Bartolome (Main)','College of Computer Studies','BS Information Technology',2),
              ('AUDIT-CS','Test','CS','Other','Batasan','College of Computer Studies','BSCS',2);");
        Audience("unrestricted", null,null,null,null,true);
        Audience("matching campus", "San Bartolome (Main)",null,null,null,true);
        Audience("wrong campus", "Batasan",null,null,null,false);
        Audience("matching college",null,"College of Computer Studies",null,null,true);
        Audience("wrong college",null,"College of Education",null,null,false);
        Audience("program code alias",null,null,"BSIT",null,true);
        Audience("program full name",null,null,"BS Information Technology",null,true);
        Audience("multi program",null,null,"BSCS, BSIT",null,true);
        Audience("wrong program",null,null,"BSEd",null,false);
        Audience("partial code cannot match",null,null,"BSI",null,false);
        Audience("wildcards cannot match",null,null,"BS%",null,false);
        Audience("matching selected year",null,null,null,2,true);
        Audience("wrong selected year",null,null,null,3,false);
        Audience("all dimensions", "San Bartolome (Main)","College of Computer Studies","BSIT",2,true);
        Audience("one mismatch rejects combined", "Batasan","College of Computer Studies","BSIT",2,false);
        Audience("blank targets unrestricted"," "," "," ",null,true);
        int unavailable = Create("window");
        Action<string, string> window = (changes, expected) => {
            Sql("UPDATE dbo.EventsTable SET " + changes + " WHERE EventId=" + unavailable);
            Check(events.GetRegistrationUnavailableReason(unavailable, "AUDIT-IT", 2).Contains(expected), expected + " reason");
            Check(registrations.RegisterStudent(Ticket(unavailable)) < 0, expected + " atomic rejection");
        };
        window("RegStart=DATEADD(hour,1,GETDATE())", "not opened");
        window("RegStart=DATEADD(day,-1,GETDATE()),RegEnd=DATEADD(second,-1,GETDATE())", "deadline has passed");
        window("RegEnd=DATEADD(day,1,GETDATE()),CurrentRegistrations=MaxCapacity", "fully booked");
        window("CurrentRegistrations=0,Status='Cancelled'", "cancelled");
        window("Status='Completed'", "ended");
        Check(events.GetRegistrationUnavailableReason(int.MaxValue,"AUDIT-IT",2).Contains("could not be found"), "unknown event denied");
        int active = Create("ticket lifecycle");
        int ticket = registrations.RegisterStudent(Ticket(active));
        var booked = registrations.GetRegistrationById(ticket);
        Check(booked.Status == "NoShow" && booked.CheckInTimestamp == null, "booking starts NoShow without attendance timestamp");
        Check(events.GetEventById(active).CurrentRegistrations == 1, "booking counter increment");
        bool duplicate = false; try { registrations.RegisterStudent(Ticket(active)); } catch(InvalidOperationException) { duplicate = true; }
        Check(duplicate && events.GetEventById(active).CurrentRegistrations == 1, "sequential duplicate blocked");
        Check(registrations.CancelRegistration(ticket), "cancellation during registration");
        Check(!registrations.CancelRegistration(ticket) && events.GetEventById(active).CurrentRegistrations == 0, "repeated cancellation cannot decrement twice");
        int replacement = registrations.RegisterStudent(Ticket(active));
        Check(replacement > 0, "rebooking cancelled registration");
        var scanned = registrations.GetRegistrationForScan(active,"AUDIT-IT");
        Check(scanned != null && scanned.EventRegistrationId == replacement, "scanner ID lookup selects current pass after rebooking");
        string error;
        Check(registrations.ConfirmCheckIn(replacement,out error), "first check-in succeeds");
        Check(!registrations.ConfirmCheckIn(replacement,out error), "duplicate check-in rejected");
        Check(!registrations.CancelRegistration(replacement), "present student cannot cancel");
        Check(!registrations.ConfirmCheckIn(ticket,out error), "cancelled ticket cannot check in");
        int deadlineEvent = Create("cancel deadline"); int deadlineTicket = registrations.RegisterStudent(Ticket(deadlineEvent));
        Sql("UPDATE dbo.EventsTable SET RegEnd=DATEADD(second,-1,GETDATE()) WHERE EventId="+deadlineEvent);
        Check(!registrations.CancelRegistration(deadlineTicket), "cancellation after deadline rejected");
        int missing = Create("missing student"); Check(registrations.RegisterStudent(Ticket(missing,"AUDIT-NOT-FOUND")) == -3,"missing profile cannot book");
        int invalidYear = Create("invalid year"); Check(registrations.RegisterStudent(Ticket(invalidYear,"AUDIT-IT",0)) == -3,"year zero rejected");
        int early = Create("check-in before event"); int earlyTicket = registrations.RegisterStudent(Ticket(early));
        Check(!registrations.ConfirmCheckIn(earlyTicket,out error), "check-in before event start blocked (policy review)");
        int emptySection = Create("empty section"); bool rejectedEmpty = false;
        try { rejectedEmpty = registrations.RegisterStudent(Ticket(emptySection,"AUDIT-IT",2,"")) < 0; } catch(ArgumentException) { rejectedEmpty = true; }
        Check(rejectedEmpty, "repository rejects empty academic section");
        for(int trial=0; trial<12; trial++) {
            int concurrent = Create("concurrent duplicate " + trial, 10);
            var gate = new ManualResetEventSlim(false);
            var tasks = Enumerable.Range(0,4).Select(i=>Task.Run(()=>{gate.Wait();try{return registrations.RegisterStudent(Ticket(concurrent));}catch(Exception){return -99;}})).ToArray();
            gate.Set(); Task.WaitAll(tasks);
            int count = Convert.ToInt32(Sql("SELECT COUNT(*) FROM dbo.EventRegistrationTable WHERE EventId="+concurrent+" AND Status<>'Cancelled'"));
            Check(count == 1, "concurrent same-student bookings create one ticket, trial " + trial);
        }
        int lastSeat=Create("last seat",1);
        var seatGate=new ManualResetEventSlim(false);
        var seats=new[]{"AUDIT-IT","AUDIT-CS"}.Select(s=>Task.Run(()=>{seatGate.Wait();return registrations.RegisterStudent(Ticket(lastSeat,s));})).ToArray();
        seatGate.Set();Task.WaitAll(seats);
        Check(seats.Count(t=>t.Result>0)==1 && events.GetEventById(lastSeat).CurrentRegistrations==1,"concurrent distinct students cannot overbook last seat");
        Console.WriteLine("RESULT: " + passes + " passed; " + findings + " findings. Isolated database only.");
        return 0; // Findings are audit output, not an interrupted test run.
    }
}
