using System;

namespace _241611JalopEventsManagement.Backend.Models
{
    /// <summary>
    /// Model representing an event sponsor record in dbo.SponsorListTable.
    /// Captures organization/corporate partnerships associated with an institutional event.
    /// </summary>
    public class SponsorModel
    {
        public int SponsorEntryId { get; set; }

        public string SponsorName { get; set; }

        public DateTime CreatedAt { get; set; } = DateTime.Now;

        public int EventId { get; set; }

        #region Navigation / Joined Display Projections

        public string EventTitle { get; set; }

        #endregion
    }
}
