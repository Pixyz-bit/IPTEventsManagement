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
            EventRepository.SynchronizeCompletedEvents();
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

            if (registration.CurrentYearLvl < 1 || registration.CurrentYearLvl > 5) return -3;

            const string sql = "dbo.usp_Registration_RegisterStudent";

            var parameters = new[]
            {
                new SqlParameter("@EventId", SqlDbType.Int) { Value = registration.EventId },
                new SqlParameter("@StudentId", SqlDbType.VarChar, 50) { Value = registration.StudentId.Trim() },
                new SqlParameter("@CurrentYearLvl", SqlDbType.Int) { Value = registration.CurrentYearLvl },
                new SqlParameter("@CurrentSection", SqlDbType.VarChar, 50) { Value = registration.CurrentSection?.Trim() ?? string.Empty }
            };

            object result = DatabaseConnection.ExecuteProcedureScalar(sql, parameters);
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

            const string sql = "dbo.usp_Registration_IsStudentRegistered";

            var parameters = new[]
            {
                new SqlParameter("@EventId", SqlDbType.Int) { Value = eventId },
                new SqlParameter("@StudentId", SqlDbType.VarChar, 50) { Value = studentId.Trim() }
            };

            object result = DatabaseConnection.ExecuteProcedureScalar(sql, parameters);
            return Convert.ToInt32(result) > 0;
        }

        /// <summary>
        /// Retrieves a registration record by its primary key identifier with event projections.
        /// </summary>
        public EventRegistrationModel GetRegistrationById(int eventRegistrationId)
        {
            EventRepository.SynchronizeCompletedEvents();
            if (eventRegistrationId <= 0)
            {
                return null;
            }

            const string sql = "dbo.usp_Registration_GetRegistrationById";

            var param = new SqlParameter("@EventRegistrationId", SqlDbType.Int) { Value = eventRegistrationId };
            DataTable dt = DatabaseConnection.ExecuteProcedureDataTable(sql, param);

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
            EventRepository.SynchronizeCompletedEvents();
            var list = new List<EventRegistrationModel>();
            if (string.IsNullOrWhiteSpace(studentId))
            {
                return list;
            }

            const string sql = "dbo.usp_Registration_GetRegistrationsByStudent";

            var param = new SqlParameter("@StudentId", SqlDbType.VarChar, 50) { Value = studentId.Trim() };
            DataTable dt = DatabaseConnection.ExecuteProcedureDataTable(sql, param);

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
            EventRepository.SynchronizeCompletedEvents();
            var list = new List<EventRegistrationModel>();
            if (eventId <= 0)
            {
                return list;
            }

            const string sql = "dbo.usp_Registration_GetRegistrationsByEvent";

            var param = new SqlParameter("@EventId", SqlDbType.Int) { Value = eventId };
            DataTable dt = DatabaseConnection.ExecuteProcedureDataTable(sql, param);

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

            const string sql = "dbo.usp_Registration_CheckInStudent";
            object id = DatabaseConnection.ExecuteProcedureScalar(sql,
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
                const string sql = "dbo.usp_Registration_GetTotalPresentAttendees";
                object result = DatabaseConnection.ExecuteProcedureScalar(sql);
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
                const string sql = "dbo.usp_Registration_GetEventAttendanceSummary";

                var param = new SqlParameter("@EventId", SqlDbType.Int) { Value = eventId };
                DataTable dt = DatabaseConnection.ExecuteProcedureDataTable(sql, param);
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
            EventRepository.SynchronizeCompletedEvents();
            if (eventRegistrationId <= 0)
            {
                return false;
            }

            const string sql = "dbo.usp_Registration_CancelRegistration";

            var param = new SqlParameter("@EventRegistrationId", SqlDbType.Int) { Value = eventRegistrationId };
            object result = DatabaseConnection.ExecuteProcedureScalar(sql, param);

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

            const string sql = "dbo.usp_Registration_AdminVoidRegistration";

            var param = new SqlParameter("@EventRegistrationId", SqlDbType.Int) { Value = eventRegistrationId };
            object result = DatabaseConnection.ExecuteProcedureScalar(sql, param);

            return Convert.ToInt32(result) > 0;
        }

        /// <summary>
        /// Looks up an attendee registration for the Attendance Scanner by ticket reference, student ID, or email.
        /// Searches target event first, then across all events to detect wrong-event passes.
        /// </summary>
        public EventRegistrationModel GetRegistrationForScan(int eventId, string query)
        {
            EventRepository.SynchronizeCompletedEvents();
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
            const string sqlTargetEvent = "dbo.usp_Registration_GetRegistrationForScan_sqlTargetEvent";

            var targetParams = new[]
            {
                new SqlParameter("@EventId", SqlDbType.Int) { Value = eventId },
                new SqlParameter("@ParsedId", SqlDbType.Int) { Value = parsedRegId },
                new SqlParameter("@Query", SqlDbType.VarChar, 100) { Value = cleaned }
            };

            DataTable dt = DatabaseConnection.ExecuteProcedureDataTable(sqlTargetEvent, targetParams);
            if (dt != null && dt.Rows.Count > 0)
            {
                return MapRowToRegistration(dt.Rows[0]);
            }

            // 2. Check across any event to detect wrong-event pass
            const string sqlAnyEvent = "dbo.usp_Registration_GetRegistrationForScan_sqlAnyEvent";

            var anyParams = new[]
            {
                new SqlParameter("@ParsedId", SqlDbType.Int) { Value = parsedRegId },
                new SqlParameter("@Query", SqlDbType.VarChar, 100) { Value = cleaned }
            };

            DataTable dtAny = DatabaseConnection.ExecuteProcedureDataTable(sqlAnyEvent, anyParams);
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
            EventRepository.SynchronizeCompletedEvents();
            errorMessage = string.Empty;
            if (eventRegistrationId <= 0)
            {
                errorMessage = "Invalid registration identifier.";
                return false;
            }

            const string sql = "dbo.usp_Registration_ConfirmCheckIn";

            var param = new SqlParameter("@EventRegistrationId", SqlDbType.Int) { Value = eventRegistrationId };
            object res = DatabaseConnection.ExecuteProcedureScalar(sql, param);
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
            EventRepository.SynchronizeCompletedEvents();
            var list = new List<EventRegistrationModel>();
            if (eventId <= 0)
            {
                return list;
            }

            const string sql = "dbo.usp_Registration_GetCheckedInAttendees";

            var param = new SqlParameter("@EventId", SqlDbType.Int) { Value = eventId };
            DataTable dt = DatabaseConnection.ExecuteProcedureDataTable(sql, param);

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
