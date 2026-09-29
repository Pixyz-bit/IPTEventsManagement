using System;

namespace _241611JalopEventsManagement.Backend.Models
{
    /// <summary>
    /// Model representing a student demographic and academic profile.
    /// Grounded directly in dbo.StudentTable and joined with dbo.UserTable.
    /// Single source of truth for student identity across registration and ticketing.
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

        public int? YearLevel { get; set; }

        public string Section { get; set; }

        public DateTime? BirthDate { get; set; }

        // Joined properties from dbo.UserTable
        public string Email { get; set; }

        public bool IsActive { get; set; } = true;

        /// <summary>
        /// Helper property returning the student's concatenated full name.
        /// </summary>
        public string FullName => string.IsNullOrWhiteSpace(MiddleName)
            ? $"{FirstName} {LastName}".Trim()
            : $"{FirstName} {MiddleName} {LastName}".Trim();

        /// <summary>
        /// Strict MM/dd/yyyy birthdate representation.
        /// </summary>
        public string FormattedBirthDate => BirthDate.HasValue 
            ? BirthDate.Value.ToString("MM/dd/yyyy") 
            : "N/A";
    }
}
