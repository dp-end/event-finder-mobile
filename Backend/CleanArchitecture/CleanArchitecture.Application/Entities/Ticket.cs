using System;

namespace CleanArchitecture.Application.Entities // (Veya senin Entities namespace'in)
{
    public class Ticket
    {
        public Guid Id { get; set; } = Guid.NewGuid();
        public DateTime PurchaseDate { get; set; } = DateTime.UtcNow;

        // Etkinlik İlişkisi (Event sınıfı da Entities içinde olduğu için birbirlerini görürler, sorun yok)
        public Guid EventId { get; set; }
        public Event Event { get; set; }

        // BURA DEĞİŞTİ: Kullanıcının sadece ID'sini tutuyoruz. 
        // Navigation property (public ApplicationUser ApplicationUser) sildik!
        public string ApplicationUserId { get; set; } 
    }
}