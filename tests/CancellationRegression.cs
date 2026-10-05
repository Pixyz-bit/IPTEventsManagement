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
        Check(new EventModel { Status = "Upcoming" }.CanCancel && !new EventModel { Status = "Completed" }.CanCancel,
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
        Check(cancellations.CancelEvent(new EventCancellationModel { EventId = 4, Reason = "Legacy mistaken event" }), "Legacy hidden event may be explicitly cancelled");
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
        Console.WriteLine("TOTAL PASSED: " + checks);
        return 0;
    }
}
