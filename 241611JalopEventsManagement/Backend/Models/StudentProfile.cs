using System;

namespace _241611JalopEventsManagement.Backend.Models
{
    /// <summary>
    /// Model representing a student demographic and academic profile.
    /// Grounded directly in dbo.StudentTable from 01_DatabaseSchema.sql.
    /// </summary>
    public class StudentProfile
    {
        public string StudentId { get; set; }

        public string FirstName { get; set; }

        public string MiddleName { get; set; }

        public string LastName { get; set; }

        public string Gender { get; set; }

        public string CampusBranch { get; set; }

        public string Department { get; set; }

        public string Program { get; set; }

        public int UserId { get; set; }

        /// <summary>
        /// Helper property returning the student's concatenated full name.
        /// </summary>
        public string FullName => string.IsNullOrWhiteSpace(MiddleName)
            ? $"{FirstName} {LastName}".Trim()
            : $"{FirstName} {MiddleName} {LastName}".Trim();
    }
}
