using System;
using System.ComponentModel.DataAnnotations;

namespace _241611JalopEventsManagement.Backend.Models
{
    public class UserModel
    {

        public int UserId { get; set; }

        [Required(ErrorMessage = "Email address is required.")]
        [EmailAddress(ErrorMessage = "Please provide a valid email format.")]
        [StringLength(150, ErrorMessage = "Email cannot exceed 150 characters.")]
        public string Email { get; set; }

        [Required(ErrorMessage = "Password is required.")]
        [DataType(DataType.Password)]
        public string Password { get; set; }

        public string PasswordHash { get; set; }

        public string PasswordSalt { get; set; }

        [StringLength(50, ErrorMessage = "Role cannot exceed 50 characters.")]
        public string Role { get; set; }

        public bool IsActive { get; set; } = true;

        public bool RememberMe { get; set; }

        /// <summary>
        /// Academic and demographic profile data (populated when Role == 'Student').
        /// </summary>
        public StudentProfile StudentProfile { get; set; }
    }
}
