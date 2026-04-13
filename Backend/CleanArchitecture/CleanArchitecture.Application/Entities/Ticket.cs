using System;

namespace CleanArchitecture.Application.Entities
{
    public class Ticket
    {
        public Guid Id { get; set; } = Guid.NewGuid();
        public DateTime PurchaseDate { get; set; } = DateTime.UtcNow;

        // QR kod verisi (UUID bazlı benzersiz string — mobil uygulama QR olarak render eder)
        public string QrCode { get; set; } = Guid.NewGuid().ToString("N");

        // Kapıda tarandıktan sonra true olur
        public bool IsUsed { get; set; } = false;

        // Görüntülenebilir bilet numarası (ör: TKT-20260413-001)
        public string TicketNumber { get; set; }

        // Etkinlik İlişkisi
        public Guid EventId { get; set; }
        public Event Event { get; set; }

        // Kullanıcı ID'si (ApplicationUser'a navigation property yok — circular dependency'den kaçınmak için)
        public string ApplicationUserId { get; set; }
    }
}
