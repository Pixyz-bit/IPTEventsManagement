using System;
using System.Security.Cryptography;

namespace _241611JalopEventsManagement.Backend.Helpers
{
    /// <summary>
    /// Cryptographic helper providing PBKDF2 salt generation and password hashing.
    /// Protects user credentials in dbo.UserTable against rainbow table and timing attacks.
    /// </summary>
    public static class PasswordHelper
    {
        private const int SaltByteSize = 32;
        private const int HashByteSize = 32;
        private const int Pbkdf2Iterations = 10000;

        /// <summary>
        /// Generates a cryptographically secure random salt formatted as a base64 string.
        /// </summary>
        public static string GenerateSalt()
        {
            byte[] salt = new byte[SaltByteSize];
            using (var rng = new RNGCryptoServiceProvider())
            {
                rng.GetBytes(salt);
            }
            return Convert.ToBase64String(salt);
        }

        /// <summary>
        /// Computes a PBKDF2 hash of the given plain-text password using the provided salt.
        /// </summary>
        public static string HashPassword(string password, string salt)
        {
            if (string.IsNullOrEmpty(password))
            {
                throw new ArgumentException("Password cannot be null or empty.", nameof(password));
            }

            if (string.IsNullOrEmpty(salt))
            {
                throw new ArgumentException("Salt cannot be null or empty.", nameof(salt));
            }

            byte[] saltBytes = Convert.FromBase64String(salt);
            using (var pbkdf2 = new Rfc2898DeriveBytes(password, saltBytes, Pbkdf2Iterations))
            {
                byte[] hash = pbkdf2.GetBytes(HashByteSize);
                return Convert.ToBase64String(hash);
            }
        }

        /// <summary>
        /// Verifies a plain-text password against a stored hash and salt using constant-time comparison.
        /// </summary>
        public static bool VerifyPassword(string enteredPassword, string storedHash, string storedSalt)
        {
            if (string.IsNullOrEmpty(enteredPassword) || string.IsNullOrEmpty(storedHash) || string.IsNullOrEmpty(storedSalt))
            {
                return false;
            }

            try
            {
                string computedHash = HashPassword(enteredPassword, storedSalt);
                return SlowEquals(Convert.FromBase64String(computedHash), Convert.FromBase64String(storedHash));
            }
            catch
            {
                return false;
            }
        }

        /// <summary>
        /// Constant-time byte array comparison preventing timing attacks.
        /// </summary>
        private static bool SlowEquals(byte[] a, byte[] b)
        {
            if (a == null || b == null || a.Length != b.Length)
            {
                return false;
            }

            int diff = 0;
            for (int i = 0; i < a.Length; i++)
            {
                diff |= a[i] ^ b[i];
            }
            return diff == 0;
        }
    }
}
