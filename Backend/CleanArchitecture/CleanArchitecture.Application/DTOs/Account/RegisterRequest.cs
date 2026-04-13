using System.ComponentModel.DataAnnotations;

namespace CleanArchitecture.Core.DTOs.Account
{
    public class RegisterRequest
    {
        [Required]
        public string FirstName { get; set; }

        // Kulüp kaydında boş bırakılabilir
        public string LastName { get; set; }

        [Required]
        [EmailAddress]
        public string Email { get; set; }

        [Required]
        [MinLength(6)]
        public string UserName { get; set; }

        [Required]
        [MinLength(6)]
        public string Password { get; set; }

        [Required]
        [Compare("Password")]
        public string ConfirmPassword { get; set; }

        // "student" veya "club" — kulüp kaydında dolu olmalı
        public string UserType { get; set; } = "student";

        // Sadece kulüp kaydında kullanılan alanlar
        public string ClubName { get; set; }
        public string AdvisorName { get; set; }
        public string PhoneNumber { get; set; }
        public string ReferenceNumber { get; set; }
        public string University { get; set; }
    }
}
