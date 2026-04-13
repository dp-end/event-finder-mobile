using System;
using System.Collections.Generic;

namespace CleanArchitecture.Application.Entities
{
    public class Event
    {
        public Guid Id { get; set; } = Guid.NewGuid();
        public string Title { get; set; }
        public string Description { get; set; }
        public DateTime Date { get; set; }
        public string Location { get; set; }       // Bina / Salon adı (ör: "Mühendislik Fak. A-101")
        public string Address { get; set; }        // Detaylı adres (ör: "Teknopark Blok C")
        public decimal Price { get; set; }
        public int Quota { get; set; }
        public string ImageUrl { get; set; }
        public bool IsActive { get; set; } = true; // Etkinlik iptal edilirse false yapılır

        // Kategori İlişkisi (Spor, Teknoloji, Müzik vb.)
        public Guid? CategoryId { get; set; }
        public Category Category { get; set; }

        // Etkinliği oluşturan kullanıcı (öğrenci ise kulüp olmayabilir)
        public string OwnerId { get; set; }

        // Kulüp İlişkisi (öğrenci etkinliği için null olabilir)
        public Guid? ClubId { get; set; }
        public Club Club { get; set; }

        // Bu etkinliğe kesilen biletler
        public ICollection<Ticket> Tickets { get; set; }

        // Yorumlar
        public ICollection<Comment> Comments { get; set; }

        // Beğeniler
        public ICollection<EventLike> Likes { get; set; }
    }
}
