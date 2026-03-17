using CleanArchitecture.Application.Entities;
using CleanArchitecture.Core.DTOs.Account;
using Microsoft.AspNetCore.Identity;
using System.Collections.Generic;
// Kendi Entity'lerimizi (Ticket) kullanabilmek için projenin entity klasörünü eklemelisin
// Örneğin: using CleanArchitecture.Application.Entities; VEYA using CleanArchitecture.Core.Entities;

namespace CleanArchitecture.Infrastructure.Models
{
    public class ApplicationUser : IdentityUser
    {
        public string FirstName { get; set; }
        public string LastName { get; set; }

        // ---- BİZİM EKLEDİĞİMİZ ALANLAR BAŞLANGIÇ ----
        public string Department { get; set; }
        public string University { get; set; }
        
        // Bir kullanıcının aldığı biletlerin listesi
        public ICollection<Ticket> Tickets { get; set; }
        // ---- BİZİM EKLEDİĞİMİZ ALANLAR BİTİŞ ----

        // Şablonun kendi kodları (Bunlara dokunmuyoruz, token güvenliği için şart)
        public List<RefreshToken> RefreshTokens { get; set; }
        public bool OwnsToken(string token)
        {
            return this.RefreshTokens?.Find(x => x.Token == token) != null;
        }
    }
}