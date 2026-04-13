using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace CleanArchitecture.Core.DTOs.Account
{
    public class AuthenticationResponse
    {
        public string Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string UserName { get; set; }
        public string Email { get; set; }
        public List<string> Roles { get; set; }
        public bool IsVerified { get; set; }
        public string JWToken { get; set; }
        [JsonIgnore]
        public string RefreshToken { get; set; }

        // Giriş sonrası frontend'e kullanıcı tipini bildirmek için
        // "Club" rolü varsa "club", yoksa "student"
        public string UserType { get; set; }

        // Kulüp admin girişinde kulübün ID'si (etkinlik oluştururken kullanılır)
        public string ClubId { get; set; }
    }
}
