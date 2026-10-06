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
        /// Only active, unfinished Upcoming events may be cancelled.
        /// </summary>
        public bool CancelEvent(EventCancellationModel cancellation)
        {
            if (cancellation == null || !cancellation.IsValid) return false;
            EventRepository.SynchronizeCompletedEvents();

            const string sql = @"
                UPDATE dbo.EventsTable
                SET Status = 'Cancelled', CancellationReason = @Reason
                WHERE EventId = @EventId AND Status = 'Upcoming' AND EventEnd > GETDATE();";

            return DatabaseConnection.ExecuteNonQuery(sql,
                new SqlParameter("@EventId", SqlDbType.Int) { Value = cancellation.EventId },
                new SqlParameter("@Reason", SqlDbType.NVarChar, EventCancellationModel.MaximumReasonLength)
                    { Value = cancellation.NormalizedReason }) == 1;
        }
    }
}
