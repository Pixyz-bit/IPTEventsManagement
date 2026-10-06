using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using _241611JalopEventsManagement.Backend.Models;

namespace _241611JalopEventsManagement.Backend.Repository
{
    public class EventRepository
    {
        // Persist completion on repository access. No background scheduler is required.
        public static void SynchronizeCompletedEvents()
        {
            DatabaseConnection.ExecuteNonQuery(@"
                UPDATE dbo.EventsTable SET Status = 'Completed'
                WHERE Status = 'Upcoming' AND EventEnd <= GETDATE();");
        }

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
                    CancellationReason, TargetBranch, TargetDepartment, TargetProgram, TargetYearLevel,
                    EventPhotoPath
                )
                VALUES (
                    @Title, @Description, @VenueLocation, @MaxCapacity, 0, 
                    @CreatedByUserId, @EventStart, @EventEnd, @RegStart, @RegEnd, @Status, 
                    @CancellationReason, @TargetBranch, @TargetDepartment, @TargetProgram, @TargetYearLevel,
                    @EventPhotoPath
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
                new SqlParameter("@Status", SqlDbType.VarChar, 50) { Value = ev.EffectiveOutcomeStatus },
                new SqlParameter("@CancellationReason", SqlDbType.NVarChar, 500) { Value = (object)ev.CancellationReason ?? DBNull.Value },
                new SqlParameter("@TargetBranch", SqlDbType.NVarChar, 100) { Value = (object)ev.TargetBranch ?? DBNull.Value },
                new SqlParameter("@TargetDepartment", SqlDbType.NVarChar, 100) { Value = (object)ev.TargetDepartment ?? DBNull.Value },
                new SqlParameter("@TargetProgram", SqlDbType.NVarChar, 100) { Value = (object)ev.TargetProgram ?? DBNull.Value },
                new SqlParameter("@TargetYearLevel", SqlDbType.Int) { Value = ev.TargetYearLevel.HasValue ? (object)ev.TargetYearLevel.Value : DBNull.Value },
                new SqlParameter("@EventPhotoPath", SqlDbType.NVarChar, 500) { Value = (object)ev.EventPhotoPath ?? DBNull.Value }
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
            SynchronizeCompletedEvents();
            if (eventId <= 0)
            {
                return null;
            }

            const string sql = @"
                SELECT EventId, Title, Description, VenueLocation, MaxCapacity, CurrentRegistrations, 
                       CreatedByUserId, EventStart, EventEnd, RegStart, RegEnd, Status, 
                       CancellationReason, TargetBranch, TargetDepartment, TargetProgram, TargetYearLevel,
                       EventPhotoPath
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
            SynchronizeCompletedEvents();
            const string sql = @"
                SELECT EventId, Title, Description, VenueLocation, MaxCapacity, CurrentRegistrations, 
                       CreatedByUserId, EventStart, EventEnd, RegStart, RegEnd, Status, 
                       CancellationReason, TargetBranch, TargetDepartment, TargetProgram, TargetYearLevel,
                       EventPhotoPath
                FROM dbo.EventsTable 
                WHERE Status = 'Upcoming'
                ORDER BY EventStart ASC;";

            DataTable dt = DatabaseConnection.ExecuteDataTable(sql);
            return MapDataTableToEventList(dt);
        }

        /// <summary>
        /// Retrieves all events across all statuses ordered by start date descending.
        /// </summary>
        public List<EventModel> GetAllEvents()
        {
            SynchronizeCompletedEvents();
            const string sql = @"
                SELECT EventId, Title, Description, VenueLocation, MaxCapacity, CurrentRegistrations, 
                       CreatedByUserId, EventStart, EventEnd, RegStart, RegEnd, Status, 
                       CancellationReason, TargetBranch, TargetDepartment, TargetProgram, TargetYearLevel,
                       EventPhotoPath
                FROM dbo.EventsTable 
                ORDER BY EventStart DESC;";

            DataTable dt = DatabaseConnection.ExecuteDataTable(sql);
            return MapDataTableToEventList(dt);
        }

        /// <summary>
        /// Retrieves events tailored for a specific student cohort using the 4-tier audience filtering matrix.
        /// An event is eligible if each target dimension is either NULL (open to all) or matches the student demographic.
        /// </summary>
        public List<EventModel> GetEventsForStudent(string branch, string department, string program, int yearLevel)
        {
            SynchronizeCompletedEvents();
            const string sql = @"
                SELECT EventId, Title, Description, VenueLocation, MaxCapacity, CurrentRegistrations, 
                       CreatedByUserId, EventStart, EventEnd, RegStart, RegEnd, Status, 
                       CancellationReason, TargetBranch, TargetDepartment, TargetProgram, TargetYearLevel,
                       EventPhotoPath
                FROM dbo.EventsTable 
                WHERE Status = 'Upcoming'
                  AND (TargetBranch IS NULL OR TargetBranch = @Branch)
                  AND (TargetDepartment IS NULL OR TargetDepartment = @Department)
                  AND (TargetProgram IS NULL OR TargetProgram = '' OR @Program IS NULL OR @Program = '' OR ',' + REPLACE(TargetProgram, ' ', '') + ',' LIKE '%,' + @Program + ',%')
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
            SynchronizeCompletedEvents();
            if (userId <= 0)
            {
                return new List<EventModel>();
            }

            const string sql = @"
                SELECT EventId, Title, Description, VenueLocation, MaxCapacity, CurrentRegistrations, 
                       CreatedByUserId, EventStart, EventEnd, RegStart, RegEnd, Status, 
                       CancellationReason, TargetBranch, TargetDepartment, TargetProgram, TargetYearLevel,
                       EventPhotoPath
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
            SynchronizeCompletedEvents();
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
                    TargetBranch = @TargetBranch,
                    TargetDepartment = @TargetDepartment,
                    TargetProgram = @TargetProgram,
                    TargetYearLevel = @TargetYearLevel,
                    EventPhotoPath = @EventPhotoPath
                WHERE EventId = @EventId AND Status = 'Upcoming' AND EventEnd > GETDATE();";

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
                new SqlParameter("@TargetBranch", SqlDbType.NVarChar, 100) { Value = (object)ev.TargetBranch ?? DBNull.Value },
                new SqlParameter("@TargetDepartment", SqlDbType.NVarChar, 100) { Value = (object)ev.TargetDepartment ?? DBNull.Value },
                new SqlParameter("@TargetProgram", SqlDbType.NVarChar, 100) { Value = (object)ev.TargetProgram ?? DBNull.Value },
                new SqlParameter("@TargetYearLevel", SqlDbType.Int) { Value = ev.TargetYearLevel.HasValue ? (object)ev.TargetYearLevel.Value : DBNull.Value },
                new SqlParameter("@EventPhotoPath", SqlDbType.NVarChar, 500) { Value = (object)ev.EventPhotoPath ?? DBNull.Value },
                new SqlParameter("@EventId", SqlDbType.Int) { Value = ev.EventId }
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
            SynchronizeCompletedEvents();
            if (eventId <= 0)
            {
                return false;
            }

            const string sql = @"
                UPDATE dbo.EventsTable 
                SET CurrentRegistrations = CurrentRegistrations + 1 
                WHERE EventId = @EventId 
                  AND CurrentRegistrations < MaxCapacity 
                  AND Status = 'Upcoming' AND EventEnd > GETDATE();";

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

        /// <summary>
        /// Retrieves historical and current campus events with attendance statistics,
        /// supporting multi-criteria filtering across Academic Year, Semester, Outcome Status, and Universal Search.
        /// </summary>
        public List<EventModel> GetHistoricalEvents(string semester = null, string academicYear = null, string outcomeStatus = null, string search = null)
        {
            SynchronizeCompletedEvents();
            string sql = @"
                SELECT e.EventId, e.Title, e.Description, e.VenueLocation, e.MaxCapacity, e.CurrentRegistrations, 
                       e.CreatedByUserId, e.EventStart, e.EventEnd, e.RegStart, e.RegEnd, e.Status, 
                       e.CancellationReason, e.TargetBranch, e.TargetDepartment, e.TargetProgram, e.TargetYearLevel,
                       e.EventPhotoPath,
                       ISNULL(regStats.PreRegisteredCount, 0) AS PreRegisteredCount,
                       ISNULL(regStats.AttendedCount, 0) AS AttendedCount,
                       ISNULL(regStats.NoShowCount, 0) AS NoShowCount,
                       ISNULL(regStats.CancelledCount, 0) AS CancelledCount
                FROM dbo.EventsTable e
                LEFT JOIN (
                    SELECT EventId,
                           COUNT(CASE WHEN Status != 'Cancelled' THEN 1 END) AS PreRegisteredCount,
                           COUNT(CASE WHEN Status = 'Present' THEN 1 END) AS AttendedCount,
                           COUNT(CASE WHEN Status = 'NoShow' THEN 1 END) AS NoShowCount,
                           COUNT(CASE WHEN Status = 'Cancelled' THEN 1 END) AS CancelledCount
                    FROM dbo.EventRegistrationTable
                    GROUP BY EventId
                ) regStats ON e.EventId = regStats.EventId
                WHERE 1 = 1";

            var parameters = new List<SqlParameter>();

            if (!string.IsNullOrWhiteSpace(search))
            {
                sql += @" AND (
                    e.Title LIKE @Search OR 
                    e.VenueLocation LIKE @Search OR 
                    e.TargetDepartment LIKE @Search OR
                    e.TargetProgram LIKE @Search
                )";
                parameters.Add(new SqlParameter("@Search", SqlDbType.NVarChar, 200) { Value = $"%{search.Trim()}%" });
            }

            if (!string.IsNullOrWhiteSpace(outcomeStatus) && !string.Equals(outcomeStatus, "ALL", StringComparison.OrdinalIgnoreCase))
            {
                if (outcomeStatus != "Upcoming" && outcomeStatus != "Cancelled" && outcomeStatus != "Completed")
                    throw new ArgumentException("Outcome status must be Upcoming, Cancelled, Completed, or ALL.", nameof(outcomeStatus));
                sql += " AND e.Status = @OutcomeStatus";
                parameters.Add(new SqlParameter("@OutcomeStatus", SqlDbType.VarChar, 50) { Value = outcomeStatus });
            }

            if (!string.IsNullOrWhiteSpace(semester) && !string.Equals(semester, "ALL", StringComparison.OrdinalIgnoreCase))
            {
                if (semester.IndexOf("1st", StringComparison.OrdinalIgnoreCase) >= 0)
                {
                    sql += " AND MONTH(e.EventStart) BETWEEN 8 AND 12";
                }
                else if (semester.IndexOf("2nd", StringComparison.OrdinalIgnoreCase) >= 0)
                {
                    sql += " AND MONTH(e.EventStart) BETWEEN 1 AND 5";
                }
                else if (semester.IndexOf("Summer", StringComparison.OrdinalIgnoreCase) >= 0)
                {
                    sql += " AND MONTH(e.EventStart) BETWEEN 6 AND 7";
                }
            }

            if (!string.IsNullOrWhiteSpace(academicYear) && !string.Equals(academicYear, "ALL", StringComparison.OrdinalIgnoreCase))
            {
                // Format expected: "2025-2026" or "A.Y. 2025-2026"
                string cleanAy = academicYear.Replace("A.Y.", "").Trim();
                string[] parts = cleanAy.Split(new[] { '-' }, StringSplitOptions.RemoveEmptyEntries);
                if (parts.Length == 2 && int.TryParse(parts[0].Trim(), out int startYear) && int.TryParse(parts[1].Trim(), out int endYear))
                {
                    sql += @" AND (
                        (MONTH(e.EventStart) >= 8 AND YEAR(e.EventStart) = @StartYear) OR 
                        (MONTH(e.EventStart) < 8 AND YEAR(e.EventStart) = @EndYear)
                    )";
                    parameters.Add(new SqlParameter("@StartYear", SqlDbType.Int) { Value = startYear });
                    parameters.Add(new SqlParameter("@EndYear", SqlDbType.Int) { Value = endYear });
                }
            }

            sql += " ORDER BY e.EventStart DESC;";

            DataTable dt = DatabaseConnection.ExecuteDataTable(sql, parameters.ToArray());
            return MapDataTableToEventList(dt);
        }

        /// <summary>
        /// Retrieves distinct academic years found across historical events for filter dropdowns.
        /// </summary>
        public List<string> GetDistinctHistoricalAcademicYears()
        {
            SynchronizeCompletedEvents();
            var years = new List<string>();
            const string sql = @"
                SELECT DISTINCT YEAR(EventStart) AS EvtYear, MONTH(EventStart) AS EvtMonth
                FROM dbo.EventsTable
                ORDER BY EvtYear DESC;";

            DataTable dt = DatabaseConnection.ExecuteDataTable(sql);
            if (dt != null)
            {
                var aySet = new HashSet<string>();
                foreach (DataRow row in dt.Rows)
                {
                    if (row["EvtYear"] != DBNull.Value && row["EvtMonth"] != DBNull.Value)
                    {
                        int y = Convert.ToInt32(row["EvtYear"]);
                        int m = Convert.ToInt32(row["EvtMonth"]);
                        string ay = m >= 8 ? $"A.Y. {y}-{y + 1}" : $"A.Y. {y - 1}-{y}";
                        aySet.Add(ay);
                    }
                }
                years.AddRange(aySet);
            }

            if (years.Count == 0)
            {
                int currentYear = DateTime.Now.Year;
                years.Add($"A.Y. {currentYear}-{currentYear + 1}");
                years.Add($"A.Y. {currentYear - 1}-{currentYear}");
            }

            return years;
        }

        #region Helper Mappings

        private static EventModel MapRowToEventModel(DataRow row)
        {
            var ev = new EventModel
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
                TargetYearLevel = row["TargetYearLevel"] != DBNull.Value ? Convert.ToInt32(row["TargetYearLevel"]) : (int?)null,
                EventPhotoPath = row.Table.Columns.Contains("EventPhotoPath") && row["EventPhotoPath"] != DBNull.Value ? row["EventPhotoPath"].ToString() : null
            };

            if (row.Table.Columns.Contains("PreRegisteredCount") && row["PreRegisteredCount"] != DBNull.Value)
            {
                ev.PreRegisteredCount = Convert.ToInt32(row["PreRegisteredCount"]);
            }
            if (row.Table.Columns.Contains("AttendedCount") && row["AttendedCount"] != DBNull.Value)
            {
                ev.AttendedCount = Convert.ToInt32(row["AttendedCount"]);
            }
            if (row.Table.Columns.Contains("NoShowCount") && row["NoShowCount"] != DBNull.Value)
            {
                ev.NoShowCount = Convert.ToInt32(row["NoShowCount"]);
            }
            if (row.Table.Columns.Contains("CancelledCount") && row["CancelledCount"] != DBNull.Value)
            {
                ev.CancelledCount = Convert.ToInt32(row["CancelledCount"]);
            }

            return ev;
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
