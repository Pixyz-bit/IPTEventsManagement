using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using _241611JalopEventsManagement.Backend.Models;

namespace _241611JalopEventsManagement.Backend.Repository
{
    public class EventRepository
    {
        public int CreateEvent(EventModel ev)
        {
            if (ev == null)
            {
                throw new ArgumentNullException(nameof(ev), "Event model cannot be null.");
            }

            if (string.IsNullOrWhiteSpace(ev.Title))
            {
                throw new ArgumentException("Event title is required.", nameof(ev.Title));
            }

            if (string.IsNullOrWhiteSpace(ev.VenueLocation))
            {
                throw new ArgumentException("Venue location is required.", nameof(ev.VenueLocation));
            }

            if (ev.MaxCapacity <= 0)
            {
                throw new ArgumentException("MaxCapacity must be greater than zero.", nameof(ev.MaxCapacity));
            }

            if (ev.CreatedByUserId <= 0)
            {
                throw new ArgumentException("CreatedByUserId must reference a valid administrator account.", nameof(ev.CreatedByUserId));
            }

            const string sql = @"
                INSERT INTO dbo.EventsTable (
                    Title, Description, VenueLocation, MaxCapacity, CurrentRegistrations, 
                    CreatedByUserId, EventStart, EventEnd, RegStart, RegEnd, Status, 
                    CancellationReason, TargetBranch, TargetDepartment, TargetProgram, TargetYearLevel
                )
                VALUES (
                    @Title, @Description, @VenueLocation, @MaxCapacity, 0, 
                    @CreatedByUserId, @EventStart, @EventEnd, @RegStart, @RegEnd, @Status, 
                    @CancellationReason, @TargetBranch, @TargetDepartment, @TargetProgram, @TargetYearLevel
                );
                SELECT CAST(SCOPE_IDENTITY() AS INT);";

            var parameters = new[]
            {
                new SqlParameter("@Title", SqlDbType.NVarChar, 200) { Value = ev.Title.Trim() },
                new SqlParameter("@Description", SqlDbType.NVarChar, -1) { Value = (object)ev.Description ?? DBNull.Value },
                new SqlParameter("@VenueLocation", SqlDbType.NVarChar, 200) { Value = ev.VenueLocation.Trim() },
                new SqlParameter("@MaxCapacity", SqlDbType.Int) { Value = ev.MaxCapacity },
                new SqlParameter("@CreatedByUserId", SqlDbType.Int) { Value = ev.CreatedByUserId },
                new SqlParameter("@EventStart", SqlDbType.DateTime) { Value = ev.EventStart },
                new SqlParameter("@EventEnd", SqlDbType.DateTime) { Value = ev.EventEnd },
                new SqlParameter("@RegStart", SqlDbType.DateTime) { Value = ev.RegStart },
                new SqlParameter("@RegEnd", SqlDbType.DateTime) { Value = ev.RegEnd },
                new SqlParameter("@Status", SqlDbType.VarChar, 50) { Value = string.IsNullOrWhiteSpace(ev.Status) ? "Upcoming" : ev.Status },
                new SqlParameter("@CancellationReason", SqlDbType.NVarChar, 500) { Value = (object)ev.CancellationReason ?? DBNull.Value },
                new SqlParameter("@TargetBranch", SqlDbType.NVarChar, 100) { Value = (object)ev.TargetBranch ?? DBNull.Value },
                new SqlParameter("@TargetDepartment", SqlDbType.NVarChar, 100) { Value = (object)ev.TargetDepartment ?? DBNull.Value },
                new SqlParameter("@TargetProgram", SqlDbType.NVarChar, 100) { Value = (object)ev.TargetProgram ?? DBNull.Value },
                new SqlParameter("@TargetYearLevel", SqlDbType.Int) { Value = ev.TargetYearLevel.HasValue ? (object)ev.TargetYearLevel.Value : DBNull.Value }
            };

            object result = DatabaseConnection.ExecuteScalar(sql, parameters);
            if (result != null && int.TryParse(result.ToString(), out int newEventId))
            {
                ev.EventId = newEventId;
                return newEventId;
            }

            throw new InvalidOperationException("Failed to retrieve generated EventId from dbo.EventsTable.");
        }

        public EventModel GetEventById(int eventId)
        {
            if (eventId <= 0)
            {
                return null;
            }

            const string sql = @"
                SELECT EventId, Title, Description, VenueLocation, MaxCapacity, CurrentRegistrations, 
                       CreatedByUserId, EventStart, EventEnd, RegStart, RegEnd, Status, 
                       CancellationReason, TargetBranch, TargetDepartment, TargetProgram, TargetYearLevel 
                FROM dbo.EventsTable 
                WHERE EventId = @EventId;";

            var param = new SqlParameter("@EventId", SqlDbType.Int) { Value = eventId };
            DataTable dt = DatabaseConnection.ExecuteDataTable(sql, param);

            if (dt != null && dt.Rows.Count > 0)
            {
                return MapRowToEventModel(dt.Rows[0]);
            }

            return null;
        }

        /// <summary>
        /// Retrieves all upcoming events ordered chronologically by start date.
        /// </summary>
        public List<EventModel> GetAllUpcomingEvents()
        {
            const string sql = @"
                SELECT EventId, Title, Description, VenueLocation, MaxCapacity, CurrentRegistrations, 
                       CreatedByUserId, EventStart, EventEnd, RegStart, RegEnd, Status, 
                       CancellationReason, TargetBranch, TargetDepartment, TargetProgram, TargetYearLevel 
                FROM dbo.EventsTable 
                WHERE Status = 'Upcoming'
                ORDER BY EventStart ASC;";

            DataTable dt = DatabaseConnection.ExecuteDataTable(sql);
            return MapDataTableToEventList(dt);
        }

        /// <summary>
        /// Retrieves events tailored for a specific student cohort using the 4-tier audience filtering matrix.
        /// An event is eligible if each target dimension is either NULL (open to all) or matches the student demographic.
        /// </summary>
        public List<EventModel> GetEventsForStudent(string branch, string department, string program, int yearLevel)
        {
            const string sql = @"
                SELECT EventId, Title, Description, VenueLocation, MaxCapacity, CurrentRegistrations, 
                       CreatedByUserId, EventStart, EventEnd, RegStart, RegEnd, Status, 
                       CancellationReason, TargetBranch, TargetDepartment, TargetProgram, TargetYearLevel 
                FROM dbo.EventsTable 
                WHERE Status = 'Upcoming'
                  AND (TargetBranch IS NULL OR TargetBranch = @Branch)
                  AND (TargetDepartment IS NULL OR TargetDepartment = @Department)
                  AND (TargetProgram IS NULL OR TargetProgram = @Program)
                  AND (TargetYearLevel IS NULL OR TargetYearLevel = @YearLevel)
                ORDER BY EventStart ASC;";

            var parameters = new[]
            {
                new SqlParameter("@Branch", SqlDbType.NVarChar, 100) { Value = (object)branch ?? DBNull.Value },
                new SqlParameter("@Department", SqlDbType.NVarChar, 100) { Value = (object)department ?? DBNull.Value },
                new SqlParameter("@Program", SqlDbType.NVarChar, 100) { Value = (object)program ?? DBNull.Value },
                new SqlParameter("@YearLevel", SqlDbType.Int) { Value = yearLevel }
            };

            DataTable dt = DatabaseConnection.ExecuteDataTable(sql, parameters);
            return MapDataTableToEventList(dt);
        }

        /// <summary>
        /// Retrieves all events created by a specific administrator.
        /// </summary>
        public List<EventModel> GetEventsCreatedByUser(int userId)
        {
            if (userId <= 0)
            {
                return new List<EventModel>();
            }

            const string sql = @"
                SELECT EventId, Title, Description, VenueLocation, MaxCapacity, CurrentRegistrations, 
                       CreatedByUserId, EventStart, EventEnd, RegStart, RegEnd, Status, 
                       CancellationReason, TargetBranch, TargetDepartment, TargetProgram, TargetYearLevel 
                FROM dbo.EventsTable 
                WHERE CreatedByUserId = @CreatedByUserId
                ORDER BY EventStart DESC;";

            var param = new SqlParameter("@CreatedByUserId", SqlDbType.Int) { Value = userId };
            DataTable dt = DatabaseConnection.ExecuteDataTable(sql, param);
            return MapDataTableToEventList(dt);
        }

        /// <summary>
        /// Updates an existing event record in dbo.EventsTable.
        /// </summary>
        public bool UpdateEvent(EventModel ev)
        {
            if (ev == null || ev.EventId <= 0)
            {
                return false;
            }

            const string sql = @"
                UPDATE dbo.EventsTable 
                SET Title = @Title,
                    Description = @Description,
                    VenueLocation = @VenueLocation,
                    MaxCapacity = @MaxCapacity,
                    EventStart = @EventStart,
                    EventEnd = @EventEnd,
                    RegStart = @RegStart,
                    RegEnd = @RegEnd,
                    Status = @Status,
                    CancellationReason = @CancellationReason,
                    TargetBranch = @TargetBranch,
                    TargetDepartment = @TargetDepartment,
                    TargetProgram = @TargetProgram,
                    TargetYearLevel = @TargetYearLevel
                WHERE EventId = @EventId;";

            var parameters = new[]
            {
                new SqlParameter("@Title", SqlDbType.NVarChar, 200) { Value = ev.Title.Trim() },
                new SqlParameter("@Description", SqlDbType.NVarChar, -1) { Value = (object)ev.Description ?? DBNull.Value },
                new SqlParameter("@VenueLocation", SqlDbType.NVarChar, 200) { Value = ev.VenueLocation.Trim() },
                new SqlParameter("@MaxCapacity", SqlDbType.Int) { Value = ev.MaxCapacity },
                new SqlParameter("@EventStart", SqlDbType.DateTime) { Value = ev.EventStart },
                new SqlParameter("@EventEnd", SqlDbType.DateTime) { Value = ev.EventEnd },
                new SqlParameter("@RegStart", SqlDbType.DateTime) { Value = ev.RegStart },
                new SqlParameter("@RegEnd", SqlDbType.DateTime) { Value = ev.RegEnd },
                new SqlParameter("@Status", SqlDbType.VarChar, 50) { Value = ev.Status },
                new SqlParameter("@CancellationReason", SqlDbType.NVarChar, 500) { Value = (object)ev.CancellationReason ?? DBNull.Value },
                new SqlParameter("@TargetBranch", SqlDbType.NVarChar, 100) { Value = (object)ev.TargetBranch ?? DBNull.Value },
                new SqlParameter("@TargetDepartment", SqlDbType.NVarChar, 100) { Value = (object)ev.TargetDepartment ?? DBNull.Value },
                new SqlParameter("@TargetProgram", SqlDbType.NVarChar, 100) { Value = (object)ev.TargetProgram ?? DBNull.Value },
                new SqlParameter("@TargetYearLevel", SqlDbType.Int) { Value = ev.TargetYearLevel.HasValue ? (object)ev.TargetYearLevel.Value : DBNull.Value },
                new SqlParameter("@EventId", SqlDbType.Int) { Value = ev.EventId }
            };

            int rows = DatabaseConnection.ExecuteNonQuery(sql, parameters);
            return rows > 0;
        }

        /// <summary>
        /// Cancels an event and records the formal cancellation reason.
        /// </summary>
        public bool CancelEvent(int eventId, string cancellationReason)
        {
            if (eventId <= 0)
            {
                return false;
            }

            const string sql = @"
                UPDATE dbo.EventsTable 
                SET Status = 'Cancelled',
                    CancellationReason = @CancellationReason
                WHERE EventId = @EventId;";

            var parameters = new[]
            {
                new SqlParameter("@CancellationReason", SqlDbType.NVarChar, 500) { Value = (object)cancellationReason ?? DBNull.Value },
                new SqlParameter("@EventId", SqlDbType.Int) { Value = eventId }
            };

            int rows = DatabaseConnection.ExecuteNonQuery(sql, parameters);
            return rows > 0;
        }

        /// <summary>
        /// Atomically increments the CurrentRegistrations counter if remaining capacity exists.
        /// Prevents concurrent registration overbooking without table locks.
        /// </summary>
        public bool IncrementRegistrationCount(int eventId)
        {
            if (eventId <= 0)
            {
                return false;
            }

            const string sql = @"
                UPDATE dbo.EventsTable 
                SET CurrentRegistrations = CurrentRegistrations + 1 
                WHERE EventId = @EventId 
                  AND CurrentRegistrations < MaxCapacity 
                  AND Status = 'Upcoming';";

            var param = new SqlParameter("@EventId", SqlDbType.Int) { Value = eventId };
            int rowsAffected = DatabaseConnection.ExecuteNonQuery(sql, param);
            return rowsAffected > 0;
        }

        /// <summary>
        /// Atomically decrements the CurrentRegistrations counter when a registration is cancelled.
        /// </summary>
        public bool DecrementRegistrationCount(int eventId)
        {
            if (eventId <= 0)
            {
                return false;
            }

            const string sql = @"
                UPDATE dbo.EventsTable 
                SET CurrentRegistrations = CurrentRegistrations - 1 
                WHERE EventId = @EventId 
                  AND CurrentRegistrations > 0;";

            var param = new SqlParameter("@EventId", SqlDbType.Int) { Value = eventId };
            int rowsAffected = DatabaseConnection.ExecuteNonQuery(sql, param);
            return rowsAffected > 0;
        }

        #region Helper Mappings

        private static EventModel MapRowToEventModel(DataRow row)
        {
            return new EventModel
            {
                EventId = Convert.ToInt32(row["EventId"]),
                Title = row["Title"]?.ToString(),
                Description = row["Description"] != DBNull.Value ? row["Description"].ToString() : null,
                VenueLocation = row["VenueLocation"]?.ToString(),
                MaxCapacity = Convert.ToInt32(row["MaxCapacity"]),
                CurrentRegistrations = Convert.ToInt32(row["CurrentRegistrations"]),
                CreatedByUserId = Convert.ToInt32(row["CreatedByUserId"]),
                EventStart = Convert.ToDateTime(row["EventStart"]),
                EventEnd = Convert.ToDateTime(row["EventEnd"]),
                RegStart = Convert.ToDateTime(row["RegStart"]),
                RegEnd = Convert.ToDateTime(row["RegEnd"]),
                Status = row["Status"]?.ToString(),
                CancellationReason = row["CancellationReason"] != DBNull.Value ? row["CancellationReason"].ToString() : null,
                TargetBranch = row["TargetBranch"] != DBNull.Value ? row["TargetBranch"].ToString() : null,
                TargetDepartment = row["TargetDepartment"] != DBNull.Value ? row["TargetDepartment"].ToString() : null,
                TargetProgram = row["TargetProgram"] != DBNull.Value ? row["TargetProgram"].ToString() : null,
                TargetYearLevel = row["TargetYearLevel"] != DBNull.Value ? Convert.ToInt32(row["TargetYearLevel"]) : (int?)null
            };
        }

        private static List<EventModel> MapDataTableToEventList(DataTable dt)
        {
            var list = new List<EventModel>();
            if (dt != null)
            {
                foreach (DataRow row in dt.Rows)
                {
                    list.Add(MapRowToEventModel(row));
                }
            }
            return list;
        }

        #endregion
    }
}
