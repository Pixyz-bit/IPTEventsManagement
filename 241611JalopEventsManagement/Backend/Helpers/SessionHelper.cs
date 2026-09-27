using System;
using System.Web;
using _241611JalopEventsManagement.Backend.Models;

namespace _241611JalopEventsManagement.Backend.Helpers
{
    /// <summary>
    /// Centralized helper managing typed session state and authentication tickets.
    /// Eliminates manual string key casting across UI code-behind files.
    /// </summary>
    public static class SessionHelper
    {
        public const string KeyUserId = "UserId";
        public const string KeyRole = "Role";
        public const string KeyEmail = "Email";
        public const string KeyStudentId = "StudentId";
        public const string KeyFirstName = "FirstName";
        public const string KeyLastName = "LastName";
        public const string KeyGender = "Gender";
        public const string KeyCampusBranch = "CampusBranch";
        public const string KeyDepartment = "Department";
        public const string KeyProgram = "Program";

        private static System.Web.SessionState.HttpSessionState Session => HttpContext.Current?.Session;

        /// <summary>
        /// Indicates whether an active user session exists.
        /// </summary>
        public static bool IsAuthenticated => CurrentUserId > 0 && !string.IsNullOrEmpty(CurrentUserRole);

        /// <summary>
        /// Indicates whether the active session has administrator rights.
        /// </summary>
        public static bool IsAdmin => string.Equals(CurrentUserRole, "Admin", StringComparison.OrdinalIgnoreCase);

        /// <summary>
        /// Indicates whether the active session is a student account.
        /// </summary>
        public static bool IsStudent => string.Equals(CurrentUserRole, "Student", StringComparison.OrdinalIgnoreCase);

        public static int CurrentUserId
        {
            get
            {
                if (Session?[KeyUserId] != null && int.TryParse(Session[KeyUserId].ToString(), out int userId))
                {
                    return userId;
                }
                return 0;
            }
        }

        public static string CurrentUserRole => Session?[KeyRole]?.ToString();

        public static string CurrentEmail => Session?[KeyEmail]?.ToString();

        public static string CurrentStudentId => Session?[KeyStudentId]?.ToString();

        public static string CurrentCampusBranch => Session?[KeyCampusBranch]?.ToString();

        public static string CurrentDepartment => Session?[KeyDepartment]?.ToString();

        public static string CurrentProgram => Session?[KeyProgram]?.ToString();

        /// <summary>
        /// Initializes the session state for an authenticated user and optional student profile.
        /// </summary>
        public static void InitializeSession(UserModel user, StudentProfile profile = null)
        {
            if (Session == null || user == null)
            {
                return;
            }

            Session[KeyUserId] = user.UserId;
            Session[KeyRole] = user.Role;
            Session[KeyEmail] = user.Email;

            if (profile != null)
            {
                Session[KeyStudentId] = profile.StudentId;
                Session[KeyFirstName] = profile.FirstName;
                Session[KeyLastName] = profile.LastName;
                Session[KeyGender] = profile.Gender;
                Session[KeyCampusBranch] = profile.CampusBranch;
                Session[KeyDepartment] = profile.Department;
                Session[KeyProgram] = profile.Program;
            }
        }

        /// <summary>
        /// Clears all session keys and abandons the current session ticket.
        /// </summary>
        public static void ClearSession()
        {
            if (Session != null)
            {
                Session.Clear();
                Session.Abandon();
            }
        }
    }
}
