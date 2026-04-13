using System;

namespace CleanArchitecture.Application.Entities
{
    public class Comment
    {
        public Guid Id { get; set; } = Guid.NewGuid();
        public string Content { get; set; }
        public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

        // Hangi etkinliğe yapıldı
        public Guid EventId { get; set; }
        public Event Event { get; set; }

        // Hangi kullanıcı yazdı (sadece ID tutuyoruz, circular dependency'den kaçınmak için)
        public string ApplicationUserId { get; set; }
        public string UserFullName { get; set; }   // Denormalized: sorgu kolaylığı için
        public string UserInitials { get; set; }   // Denormalized: avatar harfleri (AY, ZK vb.)
    }
}
