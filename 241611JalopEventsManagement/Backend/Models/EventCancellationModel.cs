namespace _241611JalopEventsManagement.Backend.Models
{
    /// <summary>An explicit request to cancel an event without deleting its history.</summary>
    public sealed class EventCancellationModel
    {
        public const int MaximumReasonLength = 500;
        public int EventId { get; set; }
        public string Reason { get; set; }
        public string NormalizedReason => Reason?.Trim();
        public bool IsValid => EventId > 0 && !string.IsNullOrWhiteSpace(NormalizedReason)
            && NormalizedReason.Length <= MaximumReasonLength;
    }
}
