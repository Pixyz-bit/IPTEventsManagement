using System;

namespace _241611JalopEventsManagement.Backend.Models
{

    public class EventRegistrationModel
    {
        public int EventRegistrationId { get; set; }

        public int EventId { get; set; }

        public string StudentId { get; set; }

        public int CurrentYearLvl { get; set; }

        public string CurrentSection { get; set; }

        public string Status { get; set; } = "NoShow"; // 'NoShow', 'Present', 'Cancelled'

        public DateTime? CheckInTimestamp { get; set; }

        #region Navigation / Joined Display Projections

        public string EventTitle { get; set; }

        public string VenueLocation { get; set; }

        public DateTime? EventStart { get; set; }

        public DateTime? EventEnd { get; set; }

        public string EventStatus { get; set; }

        public DateTime? RegStart { get; set; }

        public DateTime? RegEnd { get; set; }

        public string StudentFirstName { get; set; }

        public string StudentMiddleName { get; set; }

        public string StudentLastName { get; set; }

        public string StudentCampusBranch { get; set; }

        public string StudentProgram { get; set; }

        public string StudentDepartment { get; set; }

        public string StudentEmail { get; set; }

        public string StudentFullName => string.IsNullOrWhiteSpace(StudentMiddleName)
            ? $"{StudentFirstName} {StudentLastName}".Trim()
            : $"{StudentFirstName} {StudentMiddleName} {StudentLastName}".Trim();

        public string TicketReference => $"TCK-{EventId:D4}-{EventRegistrationId:D5}";

        public DateTime? RegistrationTimestamp { get; set; }
        public string EventPhotoPath { get; set; }

        #endregion

        #region Computed Domain Helpers

        /// <summary>
        /// Indicates whether the student attendee has successfully checked in at the event door.
        /// </summary>
        public bool IsCheckedIn => CheckInTimestamp.HasValue && string.Equals(Status, "Present", StringComparison.OrdinalIgnoreCase);

        /// <summary>
        /// Indicates whether the registration was cancelled.
        /// </summary>
        public bool IsCancelled => string.Equals(Status, "Cancelled", StringComparison.OrdinalIgnoreCase);

        /// <summary>
        /// Students can only cancel during the active registration period (before RegEnd).
        /// After the registration period ends or if already checked in / cancelled, cancellation is locked.
        /// </summary>
        public bool CanCancel => !IsCancelled && !IsCheckedIn && RegEnd.HasValue && DateTime.Now <= RegEnd.Value;

        #endregion
    }
}
