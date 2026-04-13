using CleanArchitecture.Application.Entities;
using CleanArchitecture.Core.DTOs.Account;
using Microsoft.AspNetCore.Identity;
using System.Collections.Generic;

namespace CleanArchitecture.Infrastructure.Models
{
    public class ApplicationUser : IdentityUser
    {
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Department { get; set; }
        public string University { get; set; }
        public string ProfileImageUrl { get; set; }

        // Bir kullanıcının aldığı biletlerin listesi
        public ICollection<Ticket> Tickets { get; set; }

        // Şablonun kendi kodları (token güvenliği için gerekli)
        public List<RefreshToken> RefreshTokens { get; set; }
        public bool OwnsToken(string token)
        {
            return this.RefreshTokens?.Find(x => x.Token == token) != null;
        }
    }
}
