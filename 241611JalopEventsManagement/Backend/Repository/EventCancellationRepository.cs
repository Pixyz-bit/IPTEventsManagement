using System.Data;
using System.Data.SqlClient;
using _241611JalopEventsManagement.Backend.Models;

namespace _241611JalopEventsManagement.Backend.Repository
{
    public sealed class EventCancellationRepository
    {
        /// <summary>
        /// Atomically cancels an eligible event. A repeated request cannot overwrite its reason.
        /// Existing registrations, attendance and capacity counts are retained as historical evidence.
        /// Legacy hidden events may be explicitly cancelled, but can never be restored here.
        /// </summary>
        public bool CancelEvent(EventCancellationModel cancellation)
        {
            if (cancellation == null || !cancellation.IsValid) return false;

            const string sql = @"
                UPDATE dbo.EventsTable
                SET Status = 'Cancelled', CancellationReason = @Reason
                WHERE EventId = @EventId AND Status IN ('Upcoming', 'Archived');";

            return DatabaseConnection.ExecuteNonQuery(sql,
                new SqlParameter("@EventId", SqlDbType.Int) { Value = cancellation.EventId },
                new SqlParameter("@Reason", SqlDbType.NVarChar, EventCancellationModel.MaximumReasonLength)
                    { Value = cancellation.NormalizedReason }) == 1;
        }
    }
}
