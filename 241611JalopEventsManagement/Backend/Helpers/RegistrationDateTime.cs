using System;
using System.Globalization;

namespace _241611JalopEventsManagement.Backend.Helpers
{
    // SQL DATETIME values represent local application/server time, without a UTC conversion.
    public static class RegistrationDateTime
    {
        public static string TimeZoneLabel => TimeZoneInfo.Local.BaseUtcOffset == TimeSpan.FromHours(8)
            ? "Philippine Time (UTC+08:00)"
            : TimeZoneInfo.Local.DisplayName;

        public static string ToInput(DateTime value) => value.ToString("yyyy-MM-ddTHH:mm:ss", CultureInfo.InvariantCulture);

        public static string ToDisplay(DateTime value) => value.ToString(
            value.Second == 0 ? "MM/dd/yyyy hh:mm tt" : "MM/dd/yyyy hh:mm:ss tt", CultureInfo.InvariantCulture);

        public static bool TryParse(string value, out DateTime result) => DateTime.TryParseExact(
            value?.Trim(), new[] { "yyyy-MM-ddTHH:mm", "yyyy-MM-ddTHH:mm:ss" },
            CultureInfo.InvariantCulture, DateTimeStyles.None, out result);

        public static void ValidateWindow(DateTime opening, DateTime deadline, DateTime eventStart, DateTime eventEnd)
        {
            if (eventStart >= eventEnd)
                throw new ArgumentException("Event start must precede event end.");
            if (opening >= deadline)
                throw new ArgumentException("Registration opening must precede the deadline.");
            if (opening.Date >= eventStart.Date || deadline.Date >= eventStart.Date)
                throw new ArgumentException("Registration opening and deadline must both be strictly before the event date.");
            // The schema uses SQL DATETIME, which cannot store dates before 1753.
            if (opening < System.Data.SqlTypes.SqlDateTime.MinValue.Value || eventStart < System.Data.SqlTypes.SqlDateTime.MinValue.Value)
                throw new ArgumentException("Event and registration dates must be on or after January 1, 1753.");
        }
    }
}
