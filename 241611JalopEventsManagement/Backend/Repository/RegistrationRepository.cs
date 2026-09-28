using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using _241611JalopEventsManagement.Backend.Models;

namespace _241611JalopEventsManagement.Backend.Repository
{
    /// <summary>
    /// Repository managing persistent operations on dbo.EventRegistrationTable.
    /// Handles atomic event enrollments, capacity decrement on cancellation, and door check-in timestamps.
    /// </summary>
    public class RegistrationRepository
    {
        /// <summary>
        /// Atomically registers a student for an event while checking seat availability.
        /// Returns the new EventRegistrationId on success, or -1 if the venue is at maximum capacity.
        /// </summary>
        public int RegisterStudent(EventRegistrationModel registration)
        {
            if (registration == null)
            {
                throw new ArgumentNullException(nameof(registration), "Registration model cannot be null.");
            }

            if (registration.EventId <= 0)
            {
                throw new ArgumentException("EventId must reference a valid event.", nameof(registration.EventId));
            }

            if (string.IsNullOrWhiteSpace(registration.StudentId))
            {
                throw new ArgumentException("StudentId is required for registration.", nameof(registration.StudentId));
            }

            if (IsStudentRegistered(registration.EventId, registration.StudentId))
            {
                throw new InvalidOperationException("Student is already registered for this event.");
            }

            const string sql = @"
                BEGIN TRANSACTION;

                DECLARE @Current INT, @Max INT, @RegStart DATETIME, @RegEnd DATETIME, @EvtStatus VARCHAR(50);
                SELECT @Current = CurrentRegistrations, 
                       @Max = MaxCapacity,
                       @RegStart = RegStart,
                       @RegEnd = RegEnd,
                       @EvtStatus = Status
                FROM dbo.EventsTable WITH (UPDLOCK, HOLDLOCK)
                WHERE EventId = @EventId;

                -- Registration is strictly permitted during the event's registration window
                IF @EvtStatus != 'Upcoming' OR GETDATE() < @RegStart OR GETDATE() > @RegEnd
                BEGIN
                    ROLLBACK TRANSACTION;
                    SELECT -2; -- Registration window closed or event inactive
                END
                ELSE IF @Current >= @Max
                BEGIN
                    ROLLBACK TRANSACTION;
                    SELECT -1; -- Venue capacity reached
                END
                ELSE
                BEGIN
                    -- Default status right after registration is 'NoShow'
                    INSERT INTO dbo.EventRegistrationTable (
                        EventId, StudentId, CurrentYearLvl, CurrentSection, Status, CheckInTimestamp
                    )
                    VALUES (
                        @EventId, @StudentId, @CurrentYearLvl, @CurrentSection, 'NoShow', NULL
                    );

                    DECLARE @NewId INT = CAST(SCOPE_IDENTITY() AS INT);

                    UPDATE dbo.EventsTable
                    SET CurrentRegistrations = CurrentRegistrations + 1
                    WHERE EventId = @EventId;

                    COMMIT TRANSACTION;
                    SELECT @NewId;
                END";

            var parameters = new[]
            {
                new SqlParameter("@EventId", SqlDbType.Int) { Value = registration.EventId },
                new SqlParameter("@StudentId", SqlDbType.VarChar, 50) { Value = registration.StudentId.Trim() },
                new SqlParameter("@CurrentYearLvl", SqlDbType.Int) { Value = registration.CurrentYearLvl },
                new SqlParameter("@CurrentSection", SqlDbType.VarChar, 50) { Value = registration.CurrentSection?.Trim() ?? string.Empty }
            };

            object result = DatabaseConnection.ExecuteScalar(sql, parameters);
            int newId = result != null && int.TryParse(result.ToString(), out int parsed) ? parsed : -1;

            if (newId > 0)
            {
                registration.EventRegistrationId = newId;
            }

            return newId;
        }

        /// <summary>
        /// Checks whether a student already holds an active (non-cancelled) ticket for the given event.
        /// </summary>
        public bool IsStudentRegistered(int eventId, string studentId)
        {
            if (eventId <= 0 || string.IsNullOrWhiteSpace(studentId))
            {
                return false;
            }

            const string sql = @"
                SELECT COUNT(1) 
                FROM dbo.EventRegistrationTable 
                WHERE EventId = @EventId 
                  AND StudentId = @StudentId 
                  AND Status != 'Cancelled';";

            var parameters = new[]
            {
                new SqlParameter("@EventId", SqlDbType.Int) { Value = eventId },
                new SqlParameter("@StudentId", SqlDbType.VarChar, 50) { Value = studentId.Trim() }
            };

            object result = DatabaseConnection.ExecuteScalar(sql, parameters);
            return Convert.ToInt32(result) > 0;
        }

        /// <summary>
        /// Retrieves a registration record by its primary key identifier with event projections.
        /// </summary>
        public EventRegistrationModel GetRegistrationById(int eventRegistrationId)
        {
            if (eventRegistrationId <= 0)
            {
                return null;
            }

            const string sql = @"
                SELECT r.EventRegistrationId, r.EventId, r.StudentId, r.CurrentYearLvl, r.CurrentSection, 
                       r.Status, r.CheckInTimestamp,
                       e.Title AS EventTitle, e.VenueLocation, e.EventStart, e.EventEnd, e.RegStart, e.RegEnd, e.Status AS EventStatus,
                       s.FirstName AS StudentFirstName, s.LastName AS StudentLastName, s.Program AS StudentProgram, s.Department AS StudentDepartment
                FROM dbo.EventRegistrationTable r
                INNER JOIN dbo.EventsTable e ON r.EventId = e.EventId
                INNER JOIN dbo.StudentTable s ON r.StudentId = s.StudentId
                WHERE r.EventRegistrationId = @EventRegistrationId;";

            var param = new SqlParameter("@EventRegistrationId", SqlDbType.Int) { Value = eventRegistrationId };
            DataTable dt = DatabaseConnection.ExecuteDataTable(sql, param);

            if (dt != null && dt.Rows.Count > 0)
            {
                return MapRowToRegistration(dt.Rows[0]);
            }

            return null;
        }

        /// <summary>
        /// Retrieves all event registrations booked by a specific student for their student portal.
        /// </summary>
        public List<EventRegistrationModel> GetRegistrationsByStudent(string studentId)
        {
            var list = new List<EventRegistrationModel>();
            if (string.IsNullOrWhiteSpace(studentId))
            {
                return list;
            }

            const string sql = @"
                SELECT r.EventRegistrationId, r.EventId, r.StudentId, r.CurrentYearLvl, r.CurrentSection, 
                       r.Status, r.CheckInTimestamp,
                       e.Title AS EventTitle, e.VenueLocation, e.EventStart, e.EventEnd, e.RegStart, e.RegEnd, e.Status AS EventStatus,
                       s.FirstName AS StudentFirstName, s.LastName AS StudentLastName, s.Program AS StudentProgram, s.Department AS StudentDepartment
                FROM dbo.EventRegistrationTable r
                INNER JOIN dbo.EventsTable e ON r.EventId = e.EventId
                INNER JOIN dbo.StudentTable s ON r.StudentId = s.StudentId
                WHERE r.StudentId = @StudentId
                ORDER BY e.EventStart DESC;";

            var param = new SqlParameter("@StudentId", SqlDbType.VarChar, 50) { Value = studentId.Trim() };
            DataTable dt = DatabaseConnection.ExecuteDataTable(sql, param);

            if (dt != null)
            {
                foreach (DataRow row in dt.Rows)
                {
                    list.Add(MapRowToRegistration(row));
                }
            }

            return list;
        }

        /// <summary>
        /// Retrieves the attendee manifest list for a specific event for administrative tracking and check-in.
        /// </summary>
        public List<EventRegistrationModel> GetRegistrationsByEvent(int eventId)
        {
            var list = new List<EventRegistrationModel>();
            if (eventId <= 0)
            {
                return list;
            }

            const string sql = @"
                SELECT r.EventRegistrationId, r.EventId, r.StudentId, r.CurrentYearLvl, r.CurrentSection, 
                       r.Status, r.CheckInTimestamp,
                       e.Title AS EventTitle, e.VenueLocation, e.EventStart, e.EventEnd, e.RegStart, e.RegEnd, e.Status AS EventStatus,
                       s.FirstName AS StudentFirstName, s.LastName AS StudentLastName, s.Program AS StudentProgram, s.Department AS StudentDepartment
                FROM dbo.EventRegistrationTable r
                INNER JOIN dbo.EventsTable e ON r.EventId = e.EventId
                INNER JOIN dbo.StudentTable s ON r.StudentId = s.StudentId
                WHERE r.EventId = @EventId
                ORDER BY r.EventRegistrationId ASC;";

            var param = new SqlParameter("@EventId", SqlDbType.Int) { Value = eventId };
            DataTable dt = DatabaseConnection.ExecuteDataTable(sql, param);

            if (dt != null)
            {
                foreach (DataRow row in dt.Rows)
                {
                    list.Add(MapRowToRegistration(row));
                }
            }

            return list;
        }

        /// <summary>
        /// Records attendance by updating CheckInTimestamp and setting Status to 'Present'.
        /// </summary>
        public bool CheckInStudent(int eventId, string studentId)
        {
            if (eventId <= 0 || string.IsNullOrWhiteSpace(studentId))
            {
                return false;
            }

            const string sql = @"
                UPDATE dbo.EventRegistrationTable
                SET Status = 'Present',
                    CheckInTimestamp = @CheckInTimestamp
                WHERE EventId = @EventId 
                  AND StudentId = @StudentId 
                  AND Status != 'Cancelled';";

            var parameters = new[]
            {
                new SqlParameter("@EventId", SqlDbType.Int) { Value = eventId },
                new SqlParameter("@StudentId", SqlDbType.VarChar, 50) { Value = studentId.Trim() },
                new SqlParameter("@CheckInTimestamp", SqlDbType.DateTime) { Value = DateTime.Now }
            };

            int rows = DatabaseConnection.ExecuteNonQuery(sql, parameters);
            return rows > 0;
        }

        /// <summary>
        /// Returns total count of verified checked-in attendees across all events.
        /// </summary>
        public int GetTotalPresentAttendees()
        {
            try
            {
                const string sql = "SELECT COUNT(*) FROM dbo.EventRegistrationTable WHERE Status = 'Present';";
                object result = DatabaseConnection.ExecuteScalar(sql);
                return result != null && result != DBNull.Value ? Convert.ToInt32(result) : 0;
            }
            catch
            {
                return 0;
            }
        }

        /// <summary>
        /// Cancels a student registration and atomically decrements the event's current registration count.
        /// Business Rule: Cancellations are strictly permitted ONLY during the event's active registration period (GETDATE() &lt;= RegEnd).
        /// After the registration period ends or if the student has already checked in ('Present'), cancellation is locked.
        /// </summary>
        public bool CancelRegistration(int eventRegistrationId)
        {
            if (eventRegistrationId <= 0)
            {
                return false;
            }

            const string sql = @"
                BEGIN TRANSACTION;

                DECLARE @EvtId INT, @CurStatus VARCHAR(50), @RegEnd DATETIME;

                SELECT @EvtId = r.EventId, 
                       @CurStatus = r.Status, 
                       @RegEnd = e.RegEnd
                FROM dbo.EventRegistrationTable r WITH (UPDLOCK, HOLDLOCK)
                INNER JOIN dbo.EventsTable e WITH (UPDLOCK, HOLDLOCK) ON r.EventId = e.EventId
                WHERE r.EventRegistrationId = @EventRegistrationId;

                -- Strictly enforce: 
                -- 1. Status must be default 'NoShow' (cannot cancel if already 'Present' or 'Cancelled')
                -- 2. Current time must be within registration window (GETDATE() <= RegEnd)
                IF @EvtId IS NOT NULL AND @CurStatus = 'NoShow' AND GETDATE() <= @RegEnd
                BEGIN
                    UPDATE dbo.EventRegistrationTable
                    SET Status = 'Cancelled'
                    WHERE EventRegistrationId = @EventRegistrationId;

                    UPDATE dbo.EventsTable
                    SET CurrentRegistrations = CASE 
                                                WHEN CurrentRegistrations > 0 THEN CurrentRegistrations - 1 
                                                ELSE 0 
                                               END
                    WHERE EventId = @EvtId;

                    COMMIT TRANSACTION;
                    SELECT 1;
                END
                ELSE
                BEGIN
                    ROLLBACK TRANSACTION;
                    SELECT 0;
                END";

            var param = new SqlParameter("@EventRegistrationId", SqlDbType.Int) { Value = eventRegistrationId };
            object result = DatabaseConnection.ExecuteScalar(sql, param);

            return Convert.ToInt32(result) > 0;
        }

        #region Helper Mapping

        private static EventRegistrationModel MapRowToRegistration(DataRow row)
        {
            var reg = new EventRegistrationModel
            {
                EventRegistrationId = Convert.ToInt32(row["EventRegistrationId"]),
                EventId = Convert.ToInt32(row["EventId"]),
                StudentId = row["StudentId"]?.ToString(),
                CurrentYearLvl = Convert.ToInt32(row["CurrentYearLvl"]),
                CurrentSection = row["CurrentSection"]?.ToString(),
                Status = row["Status"]?.ToString() ?? "NoShow",
                CheckInTimestamp = row["CheckInTimestamp"] != DBNull.Value ? (DateTime?)Convert.ToDateTime(row["CheckInTimestamp"]) : null
            };

            if (row.Table.Columns.Contains("EventTitle") && row["EventTitle"] != DBNull.Value)
            {
                reg.EventTitle = row["EventTitle"].ToString();
            }

            if (row.Table.Columns.Contains("VenueLocation") && row["VenueLocation"] != DBNull.Value)
            {
                reg.VenueLocation = row["VenueLocation"].ToString();
            }

            if (row.Table.Columns.Contains("EventStart") && row["EventStart"] != DBNull.Value)
            {
                reg.EventStart = Convert.ToDateTime(row["EventStart"]);
            }

            if (row.Table.Columns.Contains("EventEnd") && row["EventEnd"] != DBNull.Value)
            {
                reg.EventEnd = Convert.ToDateTime(row["EventEnd"]);
            }

            if (row.Table.Columns.Contains("RegStart") && row["RegStart"] != DBNull.Value)
            {
                reg.RegStart = Convert.ToDateTime(row["RegStart"]);
            }

            if (row.Table.Columns.Contains("RegEnd") && row["RegEnd"] != DBNull.Value)
            {
                reg.RegEnd = Convert.ToDateTime(row["RegEnd"]);
            }

            if (row.Table.Columns.Contains("EventStatus") && row["EventStatus"] != DBNull.Value)
            {
                reg.EventStatus = row["EventStatus"].ToString();
            }

            if (row.Table.Columns.Contains("StudentFirstName") && row["StudentFirstName"] != DBNull.Value)
            {
                reg.StudentFirstName = row["StudentFirstName"].ToString();
            }

            if (row.Table.Columns.Contains("StudentLastName") && row["StudentLastName"] != DBNull.Value)
            {
                reg.StudentLastName = row["StudentLastName"].ToString();
            }

            if (row.Table.Columns.Contains("StudentProgram") && row["StudentProgram"] != DBNull.Value)
            {
                reg.StudentProgram = row["StudentProgram"].ToString();
            }

            if (row.Table.Columns.Contains("StudentDepartment") && row["StudentDepartment"] != DBNull.Value)
            {
                reg.StudentDepartment = row["StudentDepartment"].ToString();
            }

            return reg;
        }

        #endregion
    }
}
