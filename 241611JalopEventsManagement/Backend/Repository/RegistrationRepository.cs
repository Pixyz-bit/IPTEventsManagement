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
                       e.Title AS EventTitle, e.VenueLocation, e.EventStart, e.EventEnd, e.RegStart, e.RegEnd, e.Status AS EventStatus, e.CancellationReason AS EventCancellationReason,
                       e.EventPhotoPath,
                       s.FirstName AS StudentFirstName, s.MiddleName AS StudentMiddleName, s.LastName AS StudentLastName, 
                       s.CampusBranch AS StudentCampusBranch, s.Program AS StudentProgram, s.Department AS StudentDepartment,
                       u.Email AS StudentEmail
                FROM dbo.EventRegistrationTable r
                INNER JOIN dbo.EventsTable e ON r.EventId = e.EventId
                INNER JOIN dbo.StudentTable s ON r.StudentId = s.StudentId
                LEFT JOIN dbo.UserTable u ON s.UserId = u.UserId
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
                       e.Title AS EventTitle, e.VenueLocation, e.EventStart, e.EventEnd, e.RegStart, e.RegEnd, e.Status AS EventStatus, e.CancellationReason AS EventCancellationReason,
                       e.EventPhotoPath,
                       s.FirstName AS StudentFirstName, s.MiddleName AS StudentMiddleName, s.LastName AS StudentLastName, 
                       s.CampusBranch AS StudentCampusBranch, s.Program AS StudentProgram, s.Department AS StudentDepartment,
                       u.Email AS StudentEmail
                FROM dbo.EventRegistrationTable r
                INNER JOIN dbo.EventsTable e ON r.EventId = e.EventId
                INNER JOIN dbo.StudentTable s ON r.StudentId = s.StudentId
                LEFT JOIN dbo.UserTable u ON s.UserId = u.UserId
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
                       e.Title AS EventTitle, e.VenueLocation, e.EventStart, e.EventEnd, e.RegStart, e.RegEnd, e.Status AS EventStatus, e.CancellationReason AS EventCancellationReason,
                       e.EventPhotoPath,
                       s.FirstName AS StudentFirstName, s.MiddleName AS StudentMiddleName, s.LastName AS StudentLastName, 
                       s.CampusBranch AS StudentCampusBranch, s.Program AS StudentProgram, s.Department AS StudentDepartment,
                       u.Email AS StudentEmail
                FROM dbo.EventRegistrationTable r
                INNER JOIN dbo.EventsTable e ON r.EventId = e.EventId
                INNER JOIN dbo.StudentTable s ON r.StudentId = s.StudentId
                LEFT JOIN dbo.UserTable u ON s.UserId = u.UserId
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

            const string sql = @"SELECT EventRegistrationId FROM dbo.EventRegistrationTable
                WHERE EventId = @EventId AND StudentId = @StudentId;";
            object id = DatabaseConnection.ExecuteScalar(sql,
                new SqlParameter("@EventId", SqlDbType.Int) { Value = eventId },
                new SqlParameter("@StudentId", SqlDbType.VarChar, 50) { Value = studentId.Trim() });
            return id != null && id != DBNull.Value && ConfirmCheckIn(Convert.ToInt32(id), out _);
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

        public class EventAttendanceSummary
        {
            public int TotalRegistered { get; set; }
            public int TotalCheckedIn { get; set; }
        }

        /// <summary>
        /// Highly optimized single-query retrieval of attendance metrics for an event.
        /// Replaces multi-table full entity joins when only aggregate counts are needed.
        /// </summary>
        public EventAttendanceSummary GetEventAttendanceSummary(int eventId)
        {
            var summary = new EventAttendanceSummary();
            if (eventId <= 0) return summary;

            try
            {
                const string sql = @"
                    SELECT 
                        COUNT(CASE WHEN Status != 'Cancelled' THEN 1 END) AS TotalRegistered,
                        COUNT(CASE WHEN Status = 'Present' THEN 1 END) AS TotalCheckedIn
                    FROM dbo.EventRegistrationTable
                    WHERE EventId = @EventId;";

                var param = new SqlParameter("@EventId", SqlDbType.Int) { Value = eventId };
                DataTable dt = DatabaseConnection.ExecuteDataTable(sql, param);
                if (dt != null && dt.Rows.Count > 0)
                {
                    summary.TotalRegistered = dt.Rows[0]["TotalRegistered"] != DBNull.Value ? Convert.ToInt32(dt.Rows[0]["TotalRegistered"]) : 0;
                    summary.TotalCheckedIn = dt.Rows[0]["TotalCheckedIn"] != DBNull.Value ? Convert.ToInt32(dt.Rows[0]["TotalCheckedIn"]) : 0;
                }
            }
            catch
            {
                // Fallback gracefully
            }
            return summary;
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

                DECLARE @EvtId INT, @CurStatus VARCHAR(50), @RegEnd DATETIME, @EvtStatus VARCHAR(50);

                SELECT @EvtId = r.EventId, 
                       @CurStatus = r.Status, 
                       @RegEnd = e.RegEnd, @EvtStatus = e.Status
                FROM dbo.EventRegistrationTable r WITH (UPDLOCK, HOLDLOCK)
                INNER JOIN dbo.EventsTable e WITH (UPDLOCK, HOLDLOCK) ON r.EventId = e.EventId
                WHERE r.EventRegistrationId = @EventRegistrationId;

                -- Strictly enforce: 
                -- 1. Status must be default 'NoShow' (cannot cancel if already 'Present' or 'Cancelled')
                -- 2. Current time must be within registration window (GETDATE() <= RegEnd)
                IF @EvtId IS NOT NULL AND @CurStatus = 'NoShow' AND GETDATE() <= @RegEnd AND @EvtStatus = 'Upcoming'
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

        /// <summary>
        /// Administrative action: Voids a registration pass and atomically increments available seats (decrements CurrentRegistrations).
        /// Migrates entry to 'Cancelled' immediately.
        /// </summary>
        public bool AdminVoidRegistration(int eventRegistrationId)
        {
            if (eventRegistrationId <= 0)
            {
                return false;
            }

            const string sql = @"
                BEGIN TRANSACTION;

                DECLARE @EvtId INT, @CurStatus VARCHAR(50);

                SELECT @EvtId = r.EventId, 
                       @CurStatus = r.Status
                FROM dbo.EventRegistrationTable r WITH (UPDLOCK, HOLDLOCK)
                WHERE r.EventRegistrationId = @EventRegistrationId;

                IF @EvtId IS NOT NULL AND @CurStatus != 'Cancelled'
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

        /// <summary>
        /// Looks up an attendee registration for the Attendance Scanner by ticket reference, student ID, or email.
        /// Searches target event first, then across all events to detect wrong-event passes.
        /// </summary>
        public EventRegistrationModel GetRegistrationForScan(int eventId, string query)
        {
            if (string.IsNullOrWhiteSpace(query))
            {
                return null;
            }

            string cleaned = query.Trim();
            int parsedRegId = 0;

            if (cleaned.StartsWith("TCK-", StringComparison.OrdinalIgnoreCase))
            {
                var parts = cleaned.Split('-');
                if (parts.Length >= 3)
                {
                    string idPart = parts[2];
                    if (idPart.Contains("|"))
                    {
                        idPart = idPart.Split('|')[0];
                    }
                    if (idPart.Contains(" "))
                    {
                        idPart = idPart.Split(' ')[0];
                    }
                    int.TryParse(idPart, out parsedRegId);
                }
            }
            else
            {
                int.TryParse(cleaned, out parsedRegId);
            }

            // 1. Check in target event
            const string sqlTargetEvent = @"
                SELECT TOP 1 r.EventRegistrationId, r.EventId, r.StudentId, r.CurrentYearLvl, r.CurrentSection, 
                       r.Status, r.CheckInTimestamp,
                       e.Title AS EventTitle, e.VenueLocation, e.EventStart, e.EventEnd, e.RegStart, e.RegEnd, e.Status AS EventStatus, e.CancellationReason AS EventCancellationReason,
                       e.EventPhotoPath,
                       s.FirstName AS StudentFirstName, s.MiddleName AS StudentMiddleName, s.LastName AS StudentLastName, 
                       s.CampusBranch AS StudentCampusBranch, s.Program AS StudentProgram, s.Department AS StudentDepartment,
                       u.Email AS StudentEmail
                FROM dbo.EventRegistrationTable r
                INNER JOIN dbo.EventsTable e ON r.EventId = e.EventId
                INNER JOIN dbo.StudentTable s ON r.StudentId = s.StudentId
                LEFT JOIN dbo.UserTable u ON s.UserId = u.UserId
                WHERE r.EventId = @EventId 
                  AND (r.EventRegistrationId = @ParsedId OR r.StudentId = @Query OR u.Email = @Query);";

            var targetParams = new[]
            {
                new SqlParameter("@EventId", SqlDbType.Int) { Value = eventId },
                new SqlParameter("@ParsedId", SqlDbType.Int) { Value = parsedRegId },
                new SqlParameter("@Query", SqlDbType.VarChar, 100) { Value = cleaned }
            };

            DataTable dt = DatabaseConnection.ExecuteDataTable(sqlTargetEvent, targetParams);
            if (dt != null && dt.Rows.Count > 0)
            {
                return MapRowToRegistration(dt.Rows[0]);
            }

            // 2. Check across any event to detect wrong-event pass
            const string sqlAnyEvent = @"
                SELECT TOP 1 r.EventRegistrationId, r.EventId, r.StudentId, r.CurrentYearLvl, r.CurrentSection, 
                       r.Status, r.CheckInTimestamp,
                       e.Title AS EventTitle, e.VenueLocation, e.EventStart, e.EventEnd, e.RegStart, e.RegEnd, e.Status AS EventStatus, e.CancellationReason AS EventCancellationReason,
                       e.EventPhotoPath,
                       s.FirstName AS StudentFirstName, s.MiddleName AS StudentMiddleName, s.LastName AS StudentLastName, 
                       s.CampusBranch AS StudentCampusBranch, s.Program AS StudentProgram, s.Department AS StudentDepartment,
                       u.Email AS StudentEmail
                FROM dbo.EventRegistrationTable r
                INNER JOIN dbo.EventsTable e ON r.EventId = e.EventId
                INNER JOIN dbo.StudentTable s ON r.StudentId = s.StudentId
                LEFT JOIN dbo.UserTable u ON s.UserId = u.UserId
                WHERE (r.EventRegistrationId = @ParsedId OR r.StudentId = @Query OR u.Email = @Query)
                ORDER BY r.EventRegistrationId DESC;";

            var anyParams = new[]
            {
                new SqlParameter("@ParsedId", SqlDbType.Int) { Value = parsedRegId },
                new SqlParameter("@Query", SqlDbType.VarChar, 100) { Value = cleaned }
            };

            DataTable dtAny = DatabaseConnection.ExecuteDataTable(sqlAnyEvent, anyParams);
            if (dtAny != null && dtAny.Rows.Count > 0)
            {
                return MapRowToRegistration(dtAny.Rows[0]);
            }

            return null;
        }

        /// <summary>
        /// Confirms attendance check-in for an attendee. Commits Status = 'Present' and CheckInTimestamp = GETDATE().
        /// Prevents duplicate check-ins or checking in cancelled tickets.
        /// </summary>
        public bool ConfirmCheckIn(int eventRegistrationId, out string errorMessage)
        {
            errorMessage = string.Empty;
            if (eventRegistrationId <= 0)
            {
                errorMessage = "Invalid registration identifier.";
                return false;
            }

            const string sql = @"
                SET XACT_ABORT ON;
                BEGIN TRANSACTION;

                DECLARE @CurStatus VARCHAR(50), @EventId INT, @EvtStatus VARCHAR(50);

                SELECT @CurStatus = Status, @EventId = EventId
                FROM dbo.EventRegistrationTable WITH (UPDLOCK, HOLDLOCK)
                WHERE EventRegistrationId = @EventRegistrationId;

                SELECT @EvtStatus = Status FROM dbo.EventsTable WITH (UPDLOCK, HOLDLOCK)
                WHERE EventId = @EventId;

                IF @CurStatus IS NULL
                BEGIN
                    ROLLBACK TRANSACTION;
                    SELECT -1; -- Not found
                END
                ELSE IF @EvtStatus IS NULL OR @EvtStatus <> 'Upcoming'
                BEGIN
                    ROLLBACK TRANSACTION;
                    SELECT -4; -- Cancelled or inactive event
                END
                ELSE IF @CurStatus = 'Present'
                BEGIN
                    ROLLBACK TRANSACTION;
                    SELECT -2; -- Already checked in
                END
                ELSE IF @CurStatus = 'Cancelled'
                BEGIN
                    ROLLBACK TRANSACTION;
                    SELECT -3; -- Cancelled pass
                END
                ELSE
                BEGIN
                    UPDATE dbo.EventRegistrationTable
                    SET Status = 'Present',
                        CheckInTimestamp = GETDATE()
                    WHERE EventRegistrationId = @EventRegistrationId;

                    COMMIT TRANSACTION;
                    SELECT 1; -- Success
                END";

            var param = new SqlParameter("@EventRegistrationId", SqlDbType.Int) { Value = eventRegistrationId };
            object res = DatabaseConnection.ExecuteScalar(sql, param);
            int code = res != null ? Convert.ToInt32(res) : -1;

            if (code == 1)
            {
                return true;
            }

            if (code == -2)
            {
                errorMessage = "This ticket has already been checked in.";
            }
            else if (code == -4)
            {
                errorMessage = "This event is cancelled or inactive. Its passes cannot be checked in.";
            }
            else if (code == -3)
            {
                errorMessage = "This registration pass was previously cancelled.";
            }
            else
            {
                errorMessage = "Attendee registration record was not found.";
            }

            return false;
        }

        /// <summary>
        /// Retrieves live chronologically checked-in attendees for the attendance scanner terminal.
        /// </summary>
        public List<EventRegistrationModel> GetCheckedInAttendees(int eventId)
        {
            var list = new List<EventRegistrationModel>();
            if (eventId <= 0)
            {
                return list;
            }

            const string sql = @"
                SELECT r.EventRegistrationId, r.EventId, r.StudentId, r.CurrentYearLvl, r.CurrentSection, 
                       r.Status, r.CheckInTimestamp,
                       e.Title AS EventTitle, e.VenueLocation, e.EventStart, e.EventEnd, e.RegStart, e.RegEnd, e.Status AS EventStatus, e.CancellationReason AS EventCancellationReason,
                       s.FirstName AS StudentFirstName, s.MiddleName AS StudentMiddleName, s.LastName AS StudentLastName, 
                       s.CampusBranch AS StudentCampusBranch, s.Program AS StudentProgram, s.Department AS StudentDepartment,
                       u.Email AS StudentEmail
                FROM dbo.EventRegistrationTable r
                INNER JOIN dbo.EventsTable e ON r.EventId = e.EventId
                INNER JOIN dbo.StudentTable s ON r.StudentId = s.StudentId
                LEFT JOIN dbo.UserTable u ON s.UserId = u.UserId
                WHERE r.EventId = @EventId AND r.Status = 'Present'
                ORDER BY r.CheckInTimestamp DESC;";

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
            if (row.Table.Columns.Contains("EventCancellationReason") && row["EventCancellationReason"] != DBNull.Value)
            {
                reg.EventCancellationReason = row["EventCancellationReason"].ToString();
            }

            if (row.Table.Columns.Contains("StudentFirstName") && row["StudentFirstName"] != DBNull.Value)
            {
                reg.StudentFirstName = row["StudentFirstName"].ToString();
            }

            if (row.Table.Columns.Contains("StudentMiddleName") && row["StudentMiddleName"] != DBNull.Value)
            {
                reg.StudentMiddleName = row["StudentMiddleName"].ToString();
            }

            if (row.Table.Columns.Contains("StudentLastName") && row["StudentLastName"] != DBNull.Value)
            {
                reg.StudentLastName = row["StudentLastName"].ToString();
            }

            if (row.Table.Columns.Contains("StudentCampusBranch") && row["StudentCampusBranch"] != DBNull.Value)
            {
                reg.StudentCampusBranch = row["StudentCampusBranch"].ToString();
            }

            if (row.Table.Columns.Contains("StudentProgram") && row["StudentProgram"] != DBNull.Value)
            {
                reg.StudentProgram = row["StudentProgram"].ToString();
            }

            if (row.Table.Columns.Contains("StudentDepartment") && row["StudentDepartment"] != DBNull.Value)
            {
                reg.StudentDepartment = row["StudentDepartment"].ToString();
            }

            if (row.Table.Columns.Contains("StudentEmail") && row["StudentEmail"] != DBNull.Value)
            {
                reg.StudentEmail = row["StudentEmail"].ToString();
            }

            if (row.Table.Columns.Contains("EventPhotoPath") && row["EventPhotoPath"] != DBNull.Value)
            {
                reg.EventPhotoPath = row["EventPhotoPath"].ToString();
            }

            return reg;
        }

        #endregion
    }
}
