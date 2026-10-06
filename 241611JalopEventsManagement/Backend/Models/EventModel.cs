using System;

namespace _241611JalopEventsManagement.Backend.Models
{
    public class EventModel
    {
        public int EventId { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public string VenueLocation { get; set; }
        public int MaxCapacity { get; set; }
        public int CurrentRegistrations { get; set; } = 0;
        public int CreatedByUserId { get; set; }
        public DateTime EventStart { get; set; }
        public DateTime EventEnd { get; set; }
        public DateTime RegStart { get; set; }
        public DateTime RegEnd { get; set; }
        private string _status = "Upcoming";
        public string Status
        {
            get => _status;
            set
            {
                if (value != "Upcoming" && value != "Cancelled" && value != "Completed")
                    throw new ArgumentException("Event status must be Upcoming, Cancelled, or Completed.", nameof(value));
                _status = value;
            }
        }
        public string CancellationReason { get; set; }

        public string TargetBranch { get; set; }
        public string TargetDepartment { get; set; }
        public string TargetProgram { get; set; }
        public int? TargetYearLevel { get; set; }

        public string EventPhotoPath { get; set; }

        // Historical reporting totals
        public int PreRegisteredCount { get; set; }
        public int AttendedCount { get; set; }
        public int NoShowCount { get; set; }
        public int CancelledCount { get; set; }

        #region Computed Domain Helpers

        public int RemainingCapacity => Math.Max(0, MaxCapacity - CurrentRegistrations);

        public double TurnoutPercentage =>
            PreRegisteredCount > 0 ? ((double)AttendedCount / PreRegisteredCount) * 100.0 : 0.0;

        public string AcademicYear
        {
            get
            {
                int year = EventStart != DateTime.MinValue ? EventStart.Year : DateTime.Now.Year;
                return (EventStart != DateTime.MinValue && EventStart.Month >= 8) 
                    ? $"A.Y. {year}-{year + 1}" 
                    : $"A.Y. {year - 1}-{year}";
            }
        }

        public string Semester
        {
            get
            {
                if (EventStart == DateTime.MinValue) return "1st Semester";
                int month = EventStart.Month;
                if (month >= 8 && month <= 12) return "1st Semester";
                if (month >= 1 && month <= 5) return "2nd Semester";
                return "Summer Term";
            }
        }

        public string EffectiveOutcomeStatus
        {
            get
            {
                if (string.Equals(Status, "Cancelled", StringComparison.OrdinalIgnoreCase))
                    return "Cancelled";
                if (string.Equals(Status, "Completed", StringComparison.OrdinalIgnoreCase))
                    return "Completed";
                if (DateTime.Now >= EventEnd)
                    return "Completed";
                return "Upcoming";
            }
        }

        public bool IsCancelled => string.Equals(Status, "Cancelled", StringComparison.OrdinalIgnoreCase);

        public bool CanCancel => EffectiveOutcomeStatus == "Upcoming";

        public string GetMatrixStatus(DateTime now)
        {
            if (Status == "Cancelled") return "Cancelled";
            if (Status == "Completed" || now >= EventEnd || now > RegEnd
                || CurrentRegistrations >= MaxCapacity) return "Close";
            return now < RegStart ? "Soon" : "Open";
        }

        public bool IsRegistrationOpen
        {
            get
            {
                DateTime now = DateTime.Now;
                return GetMatrixStatus(now) == "Open";
            }
        }

        public bool IsOpenToAll =>
            string.IsNullOrWhiteSpace(TargetBranch) &&
            string.IsNullOrWhiteSpace(TargetDepartment) &&
            string.IsNullOrWhiteSpace(TargetProgram) &&
            !TargetYearLevel.HasValue;

        #endregion
    }
}
