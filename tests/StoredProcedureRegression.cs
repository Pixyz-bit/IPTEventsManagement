using System;
using System.Data;
using System.Linq;
using _241611JalopEventsManagement.Backend.Helpers;
using _241611JalopEventsManagement.Backend.Models;
using _241611JalopEventsManagement.Backend.Repository;

public static class StoredProcedureRegression
{
    static int checks;
    static UserRepository users = new UserRepository();
    static StudentRepository students = new StudentRepository();
    static EventRepository events = new EventRepository();
    static RegistrationRepository registrations = new RegistrationRepository();
    static SponsorRepository sponsors = new SponsorRepository();
    static void Check(bool ok, string name) { if (!ok) throw new Exception("FAIL: " + name); checks++; Console.WriteLine("PASS: " + name); }
    static void Reject(Action action, string name) { bool rejected = false; try { action(); } catch { rejected = true; } Check(rejected, name); }
    static int Count(string sql) { return Convert.ToInt32(DatabaseConnection.ExecuteScalar(sql)); }
    static StudentProfile Profile(string id, string email) { return new StudentProfile { StudentId=id, Email=email,
        FirstName="Ana", MiddleName="Rose", LastName="O'Neil", Gender="Female", CampusBranch="San Bartolome",
        Department="College of Computer Studies", Program="BS Information Technology", BirthDate=new DateTime(2005,4,14), IsActive=true }; }
    static EventModel Event(int admin, string title="Procedure test", int capacity=5) { return new EventModel {
        Title=title, Description="Test", VenueLocation="Test room", MaxCapacity=capacity, CreatedByUserId=admin,
        EventStart=DateTime.Now.Date.AddDays(7).AddHours(9), EventEnd=DateTime.Now.Date.AddDays(7).AddHours(17),
        RegStart=DateTime.Now.AddDays(-1), RegEnd=DateTime.Now.AddDays(2), Status="Upcoming" }; }
    static EventRegistrationModel Ticket(int id, string student="SP-1", int year=2) { return new EventRegistrationModel {
        EventId=id, StudentId=student, CurrentYearLvl=year, CurrentSection="TEST-2A" }; }

    public static int Main()
    {
        using (var c = DatabaseConnection.GetOpenConnection())
            if (!c.Database.StartsWith("JalopStoredProcedureTest_", StringComparison.Ordinal))
                throw new Exception("Refusing to use an application database.");
        Check(Count("SELECT COUNT(*) FROM sys.procedures WHERE name LIKE 'usp[_]%'")==67,"all 67 procedures installed in isolated fixture");
        int admin=users.CreateAdminUser("admin@sp.invalid","Admin123");
        int otherAdmin=users.CreateAdminUser("other@sp.invalid","Admin123");
        Check(users.GetUserById(admin).Role=="Admin", "admin creation and ID lookup");
        Check(users.GetUserByEmail("admin@sp.invalid").UserId==admin,"email lookup");
        Check(users.EmailExists("admin@sp.invalid"),"user email existence check");
        var profile=Profile("SP-1","student@sp.invalid");
        Check(students.CreateStudentWithAccount(profile,"R04142005") && profile.UserId>0,"student and account inserted in same transaction");
        Check(students.StudentIdExists("SP-1") && students.EmailExists(profile.Email),"student duplicate queries");
        var account=users.GetUserByIdentifier("SP-1");
        Check(account.UserId==profile.UserId && account.StudentProfile.StudentId=="SP-1","student ID login projection");
        Check(PasswordHelper.VerifyPassword("R04142005",account.PasswordHash,account.PasswordSalt),"password hash and salt round trip");
        Check(students.GetStudentByUserId(profile.UserId).StudentId=="SP-1","student lookup by user ID");
        Check(students.GetAllStudents("O'Neil", "ALL", "ALL", null, "ALL").Count==1,"directory apostrophe search and unrestricted filters");
        Check(students.GetAllStudents(null,"College of Computer Studies","BS Information Technology",null,"Active").Count==1,"combined department/program/status filters");
        Check(students.GetAllStudents(null,"College of Engineering").Count==0,"nonmatching department filter");
        Check(students.GetAllStudents(null,null,null,null,"unknown").Count==1,"unknown directory status retains no-filter behavior");
        Check(students.ToggleStudentStatus("SP-1",false),"student status row count");
        Check(students.GetAllStudents(null,null,null,null,"Suspended").Count==1,"suspended filter normalization");
        Check(users.GetAllUsers(null,"Student","Locked").Count==1,"user role and locked filters");
        Check(users.GetAllUsers(null,"ALL","unknown").Count==3,"unknown account status is unrestricted");
        Check(students.ToggleStudentStatus("SP-1",true),"student reactivation");
        Check(students.ResetStudentPassword("SP-1","NewPass123"),"password reset affected rows");
        string oldHash=users.GetUserById(profile.UserId).PasswordHash;
        profile.FirstName="Anna"; profile.Email="renamed@sp.invalid";
        Check(students.UpdateStudentFull(profile),"profile and account email update");
        Check(users.GetUserById(profile.UserId).PasswordHash==oldHash,"name change preserves password");
        Check(students.GetStudentById("SP-1").Email==profile.Email,"joined email projection after update");
        int before=Count("SELECT COUNT(*) FROM dbo.UserTable");
        Reject(()=>students.CreateStudentWithAccount(Profile("SP-1","duplicate@sp.invalid"),"Test123"),"duplicate student rejected");
        Check(Count("SELECT COUNT(*) FROM dbo.UserTable")==before,"duplicate leaves no account");
        var broken=Profile("SP-BROKEN","broken@sp.invalid"); broken.Department=null;
        Reject(()=>students.CreateStudentWithAccount(broken,"Test123"),"failure after account insert rolls back");
        Check(!users.EmailExists("broken@sp.invalid"),"failed student transaction leaves no orphan account");
        Check(students.GetDistinctDepartments().Contains("College of Computer Studies"),"department list");
        Check(students.GetDistinctPrograms().Contains("BS Information Technology"),"program list");
        var managed=users.GetUserById(profile.UserId); managed.Email="managed@sp.invalid";
        profile.FirstName="Managed";
        users.SaveManagedAccount(managed,profile,null,admin);
        Check(students.GetStudentById("SP-1").FirstName=="Managed","managed account saves profile transactionally");
        Check(students.GetStudentById("SP-1").BirthDate==new DateTime(2005,4,14),"managed save preserves birthdate");
        Check(users.GetUserById(profile.UserId).PasswordHash==oldHash,"blank managed password retains hash");
        users.SaveManagedAccount(managed,profile,"Managed123",admin);
        account=users.GetUserById(profile.UserId);
        Check(PasswordHelper.VerifyPassword("Managed123",account.PasswordHash,account.PasswordSalt),"managed password update");
        managed.Email="admin@sp.invalid"; profile.FirstName="Must roll back";
        Reject(()=>users.SaveManagedAccount(managed,profile,null,admin),"managed duplicate email guard");
        Check(students.GetStudentById("SP-1").FirstName=="Managed","rejected managed save preserves profile");
        Reject(()=>users.UpdateUserRole(admin,"Student",admin),"self-demotion remains blocked");
        Reject(()=>users.ToggleUserActiveStatus(admin,admin),"self-lock remains blocked");
        Check(users.UpdateUserRole(otherAdmin,"Student",admin),"role update affected-row result");
        Check(users.ToggleUserActiveStatus(otherAdmin,admin),"account active toggle");
        Check(users.UpdateUserStatus(otherAdmin,true),"explicit user active status");
        Check(users.UpdateUserEmail(otherAdmin,"updated@sp.invalid"),"user email update");
        Reject(()=>users.UpdateUserRole(admin,"Student",otherAdmin),"last administrator safeguard retained");
        Check(users.AdminResetPassword(otherAdmin,"Reset123"),"admin password reset wrapper");
        var stats=users.GetAccountStatistics(); Check(stats.Item1==3 && stats.Item2==1,"account statistics columns and mapping");

        var ev=Event(admin); ev.TargetBranch="San Bartolome"; ev.TargetDepartment="College of Computer Studies";
        ev.TargetProgram="BSCS, BSIT"; ev.TargetYearLevel=2;
        int id=events.CreateEvent(ev);
        Check(events.GetEventById(id).Title==ev.Title,"event insertion identity and lookup");
        Check(events.GetAllUpcomingEvents().Any(e=>e.EventId==id),"upcoming events");
        Check(events.GetAllEvents().Any(e=>e.EventId==id),"all events");
        Check(events.GetEventsCreatedByUser(admin).Any(e=>e.EventId==id),"creator event query");
        Check(events.GetEventsForStudent("San Bartolome","College of Computer Studies","BS Information Technology",null).Any(e=>e.EventId==id),"audience aliases and browse without year");
        Check(!events.GetEventsForStudent("Batasan","College of Computer Studies","BSIT",2).Any(e=>e.EventId==id),"wrong branch excluded");
        Check(!events.GetEventsForStudent("San Bartolome","College of Computer Studies","BSIT",3).Any(e=>e.EventId==id),"wrong year excluded");
        Check(events.GetRegistrationUnavailableReason(id,"SP-1",2)=="","matching registration eligibility");
        Check(registrations.RegisterStudent(Ticket(id,"SP-1",3))==-3,"ineligible registration retains result code");
        int reg=registrations.RegisterStudent(Ticket(id));
        Check(reg>0 && registrations.IsStudentRegistered(id,"SP-1"),"registration ID and active check");
        Check(events.GetEventById(id).CurrentRegistrations==1,"registration count increment");
        Reject(()=>registrations.RegisterStudent(Ticket(id)),"sequential duplicate guard remains in C#");
        Check(registrations.GetRegistrationsByStudent("SP-1").Any(r=>r.EventRegistrationId==reg),"student registrations");
        Check(registrations.GetRegistrationsByEvent(id).Count==1,"event registrations");
        var pass=registrations.GetRegistrationById(reg);
        Check(pass.Status=="NoShow" && pass.CheckInTimestamp==null,"initial attendance state and projection");
        Check(registrations.GetRegistrationForScan(id,pass.TicketReference).EventRegistrationId==reg,"ticket parser and target scanner lookup");
        Check(registrations.GetRegistrationForScan(int.MaxValue,pass.TicketReference).EventId==id,"scanner cross-event fallback");
        Check(registrations.CancelRegistration(reg),"student registration cancellation");
        Check(events.GetEventById(id).CurrentRegistrations==0,"cancellation releases seat");
        reg=registrations.RegisterStudent(Ticket(id));
        Check(reg>0,"cancelled student can rebook");
        string error;
        Check(registrations.ConfirmCheckIn(reg,out error),"confirm check-in preserves current timing behavior");
        Check(!registrations.ConfirmCheckIn(reg,out error) && error.Contains("already"),"duplicate check-in rejected");
        Check(registrations.GetRegistrationById(reg).CheckInTimestamp.HasValue,"attendance timestamp mapping");
        Check(registrations.GetCheckedInAttendees(id).Count==1,"checked-in roster");
        Check(registrations.GetTotalPresentAttendees()==1,"global present count");
        var summary=registrations.GetEventAttendanceSummary(id);
        Check(summary.TotalRegistered==1 && summary.TotalCheckedIn==1,"attendance summary");
        Check(!registrations.CancelRegistration(reg),"checked-in cancellation blocked");
        Check(registrations.AdminVoidRegistration(reg),"admin void retains scalar result");
        Check(events.GetEventById(id).CurrentRegistrations==0,"admin void seat decrement");
        ev.Title="Updated procedure event"; Check(events.UpdateEvent(ev),"event update affected-row count");
        Check(events.IncrementRegistrationCount(id) && events.DecrementRegistrationCount(id),"standalone capacity updates");
        int sponsor=sponsors.AddSponsor(new SponsorModel { EventId=id,SponsorName="O'Neil Sponsor",CreatedAt=DateTime.Now });
        Check(sponsor>0 && sponsors.GetSponsorsByEventId(id).Count==1,"sponsor identity and joined lookup");
        Check(sponsors.AddSponsors(id,new[]{"Second Sponsor","Third Sponsor"})==2,"sponsor wrapper count");
        Check(sponsors.GetSponsorsForEvents(new[]{0,id,id,-1}).Single().Value.Count==3,"batched sponsor ID parameter and deduplication");
        Check(sponsors.DeleteSponsor(sponsor),"sponsor delete affected rows");
        Check(sponsors.DeleteSponsorsByEventId(id),"event sponsor delete affected rows");
        Check(new EventCancellationRepository().CancelEvent(new EventCancellationModel { EventId=id,Reason="Test cancellation" }),"whole-event cancellation");
        Check(events.GetEventById(id).Status=="Cancelled","cancelled status");
        Check(events.GetHistoricalEvents(outcomeStatus:"Cancelled",search:"procedure").Any(e=>e.EventId==id),"history outcome and search");
        Check(events.GetHistoricalEvents(semester:"unknown",academicYear:"bad",outcomeStatus:"ALL").Any(e=>e.EventId==id),"history invalid optional values retain no-filter behavior");
        string semester=ev.EventStart.Month>=8?"1st":ev.EventStart.Month<=5?"2nd":"Summer";
        int year=ev.EventStart.Month>=8?ev.EventStart.Year:ev.EventStart.Year-1;
        Check(events.GetHistoricalEvents(semester,year+"-"+(year+1),"Cancelled").Any(e=>e.EventId==id),"history semester and academic year parameters");
        Check(events.GetDistinctHistoricalAcademicYears().Count>0,"history academic year mapping");
        Reject(()=>events.GetHistoricalEvents(outcomeStatus:"Invalid"),"history validation remains in C#");
        Console.WriteLine("RESULT: "+checks+" stored-procedure integration checks passed.");
        return 0;
    }
}
