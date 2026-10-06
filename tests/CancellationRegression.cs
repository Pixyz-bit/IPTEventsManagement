using System;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using _241611JalopEventsManagement.Backend.Models;
using _241611JalopEventsManagement.Backend.Repository;

// Run only with an executable configuration pointing to a disposable JalopCancellationTest_* database.
public static class CancellationRegression
{
    static int checks;
    static void Check(bool value, string name)
    {
        if (!value) throw new Exception("FAIL: " + name);
        checks++;
        Console.WriteLine("PASS: " + name);
    }
    static object Scalar(string sql)
    {
        using (var c = DatabaseConnection.GetOpenConnection())
        using (var q = new SqlCommand(sql, c)) return q.ExecuteScalar();
    }
    public static int Main()
    {
        var builder = new SqlConnectionStringBuilder(DatabaseConnection.ConnectionString);
        if (!builder.InitialCatalog.StartsWith("JalopCancellationTest_", StringComparison.Ordinal)
            || builder.DataSource != @"(localdb)\MSSQLLocalDB")
            throw new Exception("Refusing to run against anything except the disposable LocalDB fixture.");

        var cancellations = new EventCancellationRepository();
        var events = new EventRepository();
        var registrations = new RegistrationRepository();
        Check(!cancellations.CancelEvent(null), "Null cancellation rejected");
        Check(!cancellations.CancelEvent(new EventCancellationModel { EventId = 1, Reason = "  " }), "Blank reason rejected");
        Check(!cancellations.CancelEvent(new EventCancellationModel { EventId = 1, Reason = new string('x', 501) }), "Oversized reason rejected");
        Check(!cancellations.CancelEvent(new EventCancellationModel { EventId = 0, Reason = "Mistake" }), "Invalid event ID rejected");
        Check(new EventCancellationModel { EventId = 1, Reason = new string('x', 500) }.IsValid, "500 character boundary accepted");
        Check(new EventModel { Status = "Upcoming", EventEnd = DateTime.Now.AddDays(1) }.CanCancel && !new EventModel { Status = "Completed" }.CanCancel,
            "Model eligibility agrees with lifecycle rules");
        Check(cancellations.CancelEvent(new EventCancellationModel { EventId = 1, Reason = "  Mistake — <script>alert(1)</script>  " }), "Upcoming event cancelled");
        var cancelled = events.GetEventById(1);
        Check(cancelled.IsCancelled && cancelled.CancellationReason == "Mistake — <script>alert(1)</script>", "Trimmed Unicode reason saved");
        Check(!cancelled.IsRegistrationOpen && !cancelled.CanCancel, "Cancelled event cannot register or cancel again");
        Check(Convert.ToInt32(Scalar("SELECT COUNT(*) FROM dbo.EventRegistrationTable WHERE EventId=1")) == 2
            && cancelled.CurrentRegistrations == 2, "Registrations and capacity history retained");
        Check(Convert.ToString(Scalar("SELECT Status FROM dbo.EventRegistrationTable WHERE EventRegistrationId=2")) == "Present"
            && Scalar("SELECT CheckInTimestamp FROM dbo.EventRegistrationTable WHERE EventRegistrationId=2") != DBNull.Value,
            "Historical attendance preserved");
        var pass = registrations.GetRegistrationById(1);
        Check(pass.IsEventCancelled && !pass.IsPassValid && !pass.CanCancel && pass.EventCancellationReason == cancelled.CancellationReason,
            "Joined pass detects cancelled event and reason");
        string error;
        Check(!registrations.ConfirmCheckIn(1, out error) && error.Contains("cancelled"), "Direct scanner commit blocked");
        Check(!registrations.CheckInStudent(1, "TEST-1"), "Legacy check-in API cannot bypass cancellation");
        Check(!registrations.CancelRegistration(1), "Student cancellation cannot alter event-wide cancellation history");
        Check(registrations.RegisterStudent(new EventRegistrationModel { EventId = 1, StudentId = "TEST-3", CurrentYearLvl = 1, CurrentSection = "TEST" }) == -2,
            "Repository blocks new registration after cancellation");
        cancelled.Status = "Upcoming";
        cancelled.Title = "Attempted resurrection";
        Check(!events.UpdateEvent(cancelled) && events.GetEventById(1).IsCancelled, "Stale edit cannot reactivate cancellation");
        Check(!cancellations.CancelEvent(new EventCancellationModel { EventId = 1, Reason = "Overwrite" })
            && events.GetEventById(1).CancellationReason.Contains("Mistake"), "Repeat cancellation preserves original reason");
        Check(!cancellations.CancelEvent(new EventCancellationModel { EventId = 2, Reason = "Mistake" }), "Completed event protected");
        Check(!cancellations.CancelEvent(new EventCancellationModel { EventId = 3, Reason = "Overwrite" })
            && events.GetEventById(3).CancellationReason == "Original reason", "Previously cancelled event protected");
        Check(cancellations.CancelEvent(new EventCancellationModel { EventId = 4, Reason = "Created by mistake" }), "Another upcoming event may be cancelled");
        Check(!cancellations.CancelEvent(new EventCancellationModel { EventId = 99999, Reason = "Missing" }), "Missing event fails safely");
        var editable = events.GetEventById(5);
        editable.Title = "Updated title";
        editable.Status = "Cancelled";
        editable.CancellationReason = "Unauthorized lifecycle edit";
        Check(events.UpdateEvent(editable) && events.GetEventById(5).Status == "Upcoming"
            && events.GetEventById(5).CancellationReason == null, "Ordinary editing preserves lifecycle and reason");
        Check(registrations.ConfirmCheckIn(3, out error), "Active event check-in still works");
        Check(!registrations.ConfirmCheckIn(3, out error) && error.Contains("already"), "Duplicate check-in still blocked");
        var tasks = Enumerable.Range(0, 8).Select(i => Task.Run(() => cancellations.CancelEvent(
            new EventCancellationModel { EventId = 6, Reason = "Concurrent request " + i }))).ToArray();
        Task.WaitAll(tasks);
        Check(tasks.Count(t => t.Result) == 1, "Concurrent cancellation succeeds exactly once");
        Check(events.GetHistoricalEvents(outcomeStatus: "Cancelled").Any(e => e.EventId == 1), "Cancelled event remains in history");
        foreach (string unsupported in new[] { "Archived", "Concluded", "Open", "Soon", "Close", "upcoming", "Upcoming " })
        {
            bool rejected = false;
            try { new EventModel { Status = unsupported }; }
            catch (ArgumentException) { rejected = true; }
            Check(rejected, "Model rejects unsupported event status: " + unsupported);
            rejected = false;
            try { Scalar("UPDATE dbo.EventsTable SET Status='" + unsupported + "' WHERE EventId=7;"); }
            catch (SqlException) { rejected = true; }
            Check(rejected && events.GetEventById(7).Status == "Upcoming", "Database rejects unsupported event status: " + unsupported);
        }
        DateTime now = DateTime.Now;
        var matrixEvent = new EventModel { EventEnd = now.AddDays(2), RegStart = now, RegEnd = now.AddDays(1), MaxCapacity = 50 };
        Check(matrixEvent.GetMatrixStatus(now.AddTicks(-1)) == "Soon", "Soon before registration starts");
        Check(matrixEvent.GetMatrixStatus(now) == "Open", "Open at registration start");
        Check(matrixEvent.GetMatrixStatus(matrixEvent.RegEnd) == "Open", "Registration deadline is inclusive");
        Check(matrixEvent.GetMatrixStatus(matrixEvent.RegEnd.AddTicks(1)) == "Close", "Close immediately after deadline");
        matrixEvent.CurrentRegistrations = 50;
        Check(matrixEvent.GetMatrixStatus(now) == "Close", "Full event closes registration");
        matrixEvent.Status = "Cancelled";
        Check(matrixEvent.GetMatrixStatus(now.AddDays(-1)) == "Cancelled", "Cancellation overrides dates and capacity");

        Scalar(@"INSERT INTO dbo.EventsTable (Title,VenueLocation,MaxCapacity,CurrentRegistrations,CreatedByUserId,EventStart,EventEnd,RegStart,RegEnd,Status)
            VALUES ('Ended lifecycle fixture','Test venue',50,1,1,DATEADD(hour,-2,GETDATE()),DATEADD(hour,-1,GETDATE()),DATEADD(day,-1,GETDATE()),DATEADD(day,1,GETDATE()),'Upcoming');
            DECLARE @EndedId INT = SCOPE_IDENTITY();
            INSERT INTO dbo.EventRegistrationTable (EventId,StudentId,CurrentYearLvl,CurrentSection,Status) VALUES (@EndedId,'TEST-1',1,'TEST','NoShow');
            SELECT @EndedId;");
        int endedId = Convert.ToInt32(Scalar("SELECT EventId FROM dbo.EventsTable WHERE Title='Ended lifecycle fixture'"));
        int endedRegistrationId = Convert.ToInt32(Scalar("SELECT EventRegistrationId FROM dbo.EventRegistrationTable WHERE EventId=" + endedId));
        var ended = events.GetEventById(endedId);
        Check(ended.Status == "Completed" && Convert.ToString(Scalar("SELECT Status FROM dbo.EventsTable WHERE EventId=" + endedId)) == "Completed", "Completion persists on repository access");
        Check(!ended.CanCancel && !ended.IsRegistrationOpen && ended.GetMatrixStatus(now) == "Close", "Ended event has consistent domain state");
        Check(!cancellations.CancelEvent(new EventCancellationModel { EventId = endedId, Reason = "Too late" }), "Ended event cannot be cancelled");
        ended.EventEnd = DateTime.Now.AddDays(1);
        Check(!events.UpdateEvent(ended), "Ended event cannot be edited back into activity");
        Check(!registrations.ConfirmCheckIn(endedRegistrationId, out error), "Ended event cannot check in");
        Check(!registrations.GetRegistrationById(endedRegistrationId).IsPassValid, "Ended event pass is invalid");
        Check(registrations.RegisterStudent(new EventRegistrationModel { EventId = endedId, StudentId = "TEST-3", CurrentYearLvl = 1 }) == -2, "Ended event cannot register even with a future deadline");
        Check(events.GetHistoricalEvents(outcomeStatus: "Completed").Any(e => e.EventId == endedId), "History filters persisted completion");
        Scalar("DELETE FROM dbo.EventRegistrationTable WHERE EventId=" + endedId + "; DELETE FROM dbo.EventsTable WHERE EventId=" + endedId + ";");
        int audienceId = Convert.ToInt32(Scalar(@"INSERT INTO dbo.EventsTable
            (Title,VenueLocation,MaxCapacity,CurrentRegistrations,CreatedByUserId,EventStart,EventEnd,RegStart,RegEnd,Status,
             TargetBranch,TargetDepartment,TargetProgram,TargetYearLevel)
            VALUES ('Audience fixture','Test venue',50,0,1,DATEADD(day,2,GETDATE()),DATEADD(day,3,GETDATE()),
                DATEADD(day,-1,GETDATE()),DATEADD(day,1,GETDATE()),'Upcoming',
                'San Bartolome','College of Computer Studies','BSCS, BSIT',2); SELECT SCOPE_IDENTITY();"));
        var audienceRegistration = new EventRegistrationModel { EventId = audienceId, StudentId = "TEST-3", CurrentYearLvl = 1, CurrentSection = "TEST" };
        Check(events.GetEventsForStudent("San Bartolome", "College of Computer Studies", "BSIT", null).Any(e => e.EventId == audienceId), "Catalog lists year-restricted events for browsing before filling the registration form");
        Check(!events.GetEventsForStudent("San Bartolome", "College of Computer Studies", "BSIT", 1).Any(e => e.EventId == audienceId), "Catalog excludes wrong year");
        Check(events.GetEventsForStudent("San Bartolome", "College of Computer Studies", "BSIT", 2).Any(e => e.EventId == audienceId), "Catalog matches whole program in multi-program audience");
        Check(!events.GetEventsForStudent("Batasan", "College of Computer Studies", "BSIT", null).Any(e => e.EventId == audienceId), "Campus mismatch hides event even when program matches");
        Check(!events.GetEventsForStudent("San Bartolome", "College of Engineering", "BSIT", null).Any(e => e.EventId == audienceId), "Department mismatch hides event even when program matches");
        Check(!events.GetEventsForStudent(null, null, "BSIT", null).Any(e => e.EventId == audienceId), "Missing campus and department cannot bypass restrictions");
        Check(events.GetEventsForStudent(" San Bartolome ", " College of Computer Studies ", " BS Information Technology ", 2).Any(e => e.EventId == audienceId), "Whitespace and full program name match all configured restrictions");
        Check(!events.GetEventsForStudent("San Bartolome", "College of Computer Studies", "BS", 2).Any(e => e.EventId == audienceId), "Partial program does not match");
        Check(!events.GetEventsForStudent("San Bartolome", "College of Computer Studies", null, 2).Any(e => e.EventId == audienceId), "Unknown program cannot bypass program restriction");
        Check(registrations.RegisterStudent(audienceRegistration) == -3, "Direct registration rejects wrong year");
        audienceRegistration.CurrentYearLvl = 2;
        foreach (string restriction in new[] { "TargetBranch='Batasan'", "TargetDepartment='Other college'", "TargetProgram='BSCS'" })
        {
            Scalar("UPDATE dbo.EventsTable SET " + restriction + " WHERE EventId=" + audienceId);
            Check(registrations.RegisterStudent(audienceRegistration) == -3, "Registration rechecks " + restriction);
            Scalar("UPDATE dbo.EventsTable SET TargetBranch='San Bartolome',TargetDepartment='College of Computer Studies',TargetProgram='BSCS, BSIT' WHERE EventId=" + audienceId);
        }
        Check(events.GetEventById(audienceId).CurrentRegistrations == 0 && Convert.ToInt32(Scalar("SELECT COUNT(*) FROM dbo.EventRegistrationTable WHERE EventId=" + audienceId)) == 0, "Rejected registrations do not consume seats or create passes");
        audienceRegistration.CurrentYearLvl = 0;
        Check(registrations.RegisterStudent(audienceRegistration) == -3, "Missing year rejected without a default");
        audienceRegistration.CurrentYearLvl = 2;
        Check(registrations.RegisterStudent(audienceRegistration) > 0 && events.GetEventById(audienceId).CurrentRegistrations == 1, "Eligible registration saves a pass and consumes one seat");
        Scalar("DELETE FROM dbo.EventRegistrationTable WHERE EventId=" + audienceId + "; UPDATE dbo.EventsTable SET CurrentRegistrations=0,TargetYearLevel=NULL WHERE EventId=" + audienceId);
        Check(events.GetEventsForStudent("San Bartolome", "College of Computer Studies", "BSIT", null).Any(e => e.EventId == audienceId), "Unknown year may see unrestricted-year events");
        audienceRegistration.CurrentYearLvl = 5;
        Check(registrations.RegisterStudent(audienceRegistration) > 0, "Existing Irregular choice works for unrestricted-year events");
        Scalar("DELETE FROM dbo.EventRegistrationTable WHERE EventId=" + audienceId + "; UPDATE dbo.EventsTable SET CurrentRegistrations=0,TargetProgram='BSA' WHERE EventId=" + audienceId + "; UPDATE dbo.StudentTable SET Program='BS Accountancy' WHERE StudentId='TEST-3';");
        Check(events.GetEventsForStudent("San Bartolome", "College of Computer Studies", "BS Accountancy", null).Any(e => e.EventId == audienceId), "BSA event is visible to a BS Accountancy profile without year selection");
        Check(!events.GetEventsForStudent("San Bartolome", "College of Computer Studies", "BS Business Administration", null).Any(e => e.EventId == audienceId), "BSA does not match the different BSBA program");
        Check(registrations.RegisterStudent(audienceRegistration) > 0, "Registration recognizes BS Accountancy as BSA");
        Scalar("DELETE FROM dbo.EventRegistrationTable WHERE EventId=" + audienceId + "; UPDATE dbo.EventsTable SET CurrentRegistrations=0,TargetProgram='BS Accountancy' WHERE EventId=" + audienceId + "; UPDATE dbo.StudentTable SET Program='BSA' WHERE StudentId='TEST-3';");
        Check(events.GetEventsForStudent("San Bartolome", "College of Computer Studies", "BSA", null).Any(e => e.EventId == audienceId), "Full-name event target matches a program code profile");
        Check(registrations.RegisterStudent(audienceRegistration) > 0, "Registration supports reverse full-name target matching");
        Scalar("UPDATE dbo.StudentTable SET Program='BSIT' WHERE StudentId='TEST-3';");
        Scalar("DELETE FROM dbo.EventRegistrationTable WHERE EventId=" + audienceId + "; UPDATE dbo.EventsTable SET CurrentRegistrations=0,TargetBranch=NULL,TargetDepartment=NULL,TargetProgram=NULL WHERE EventId=" + audienceId);
        Check(events.GetEventsForStudent("Batasan", "College of Education", "Bachelor of Early Childhood Education", null).Any(e => e.EventId == audienceId), "Unrestricted event is visible across campus department and program");
        foreach (int eligibleYear in new[] { 1, 2, 3, 4 })
        {
            Scalar("UPDATE dbo.EventsTable SET TargetYearLevel=" + eligibleYear + " WHERE EventId=" + audienceId);
            audienceRegistration.CurrentYearLvl = eligibleYear == 4 ? 1 : eligibleYear + 1;
            Check(registrations.RegisterStudent(audienceRegistration) == -3, "Year " + eligibleYear + " restriction rejects a different submitted year");
            audienceRegistration.CurrentYearLvl = 5;
            Check(registrations.RegisterStudent(audienceRegistration) == -3, "Irregular does not bypass year " + eligibleYear + " restriction");
            audienceRegistration.CurrentYearLvl = eligibleYear;
            Check(registrations.RegisterStudent(audienceRegistration) > 0, "Year " + eligibleYear + " restriction accepts the matching form year");
            Scalar("DELETE FROM dbo.EventRegistrationTable WHERE EventId=" + audienceId + "; UPDATE dbo.EventsTable SET CurrentRegistrations=0 WHERE EventId=" + audienceId);
        }
        string[,] programs = {
            { "BSIT", "BS Information Technology" }, { "BSCS", "BS Computer Science" },
            { "BSIS", "BS Information Systems" }, { "BSIE", "BS Industrial Engineering" },
            { "BSCpE", "BS Computer Engineering" }, { "BSECE", "BS Electronics Engineering" },
            { "BSA", "BS Accountancy" }, { "BSBA", "BS Business Administration" },
            { "BSEntrep", "BS Entrepreneurship" }, { "BECEd", "Bachelor of Early Childhood Education" },
            { "BSEd", "BS Secondary Education" }, { "BSEd", "Bachelor of Secondary Education" }
        };
        for (int i = 0; i < programs.GetLength(0); i++)
        {
            Scalar("UPDATE dbo.EventsTable SET TargetYearLevel=NULL,TargetProgram='" + programs[i,0] + "' WHERE EventId=" + audienceId);
            Check(events.GetEventsForStudent("Batasan", "College of Education", programs[i,1], null).Any(e => e.EventId == audienceId), "Program code recognizes " + programs[i,1]);
            Scalar("UPDATE dbo.EventsTable SET TargetProgram='" + programs[i,1] + "' WHERE EventId=" + audienceId);
            Check(events.GetEventsForStudent("Batasan", "College of Education", programs[i,0], null).Any(e => e.EventId == audienceId), "Program name recognizes " + programs[i,0]);
        }
        Scalar("DELETE FROM dbo.EventRegistrationTable WHERE EventId=" + audienceId + "; DELETE FROM dbo.EventsTable WHERE EventId=" + audienceId);
        Console.WriteLine("TOTAL PASSED: " + checks);
        return 0;
    }
}
