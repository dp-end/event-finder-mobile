using System;

namespace CleanArchitecture.Core.DTOs.Event
{
    // Listeleme ve detay görüntüleme için
    public class EventDto
    {
        public Guid Id { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }
        public DateTime Date { get; set; }
        public string Location { get; set; }
        public string Address { get; set; }
        public decimal Price { get; set; }
        public int Quota { get; set; }
        public int RemainingQuota { get; set; }   // Kalan kontenjan (Quota - satılan bilet sayısı)
        public string ImageUrl { get; set; }
        public bool IsActive { get; set; }

        // Kategori bilgisi
        public Guid? CategoryId { get; set; }
        public string CategoryName { get; set; }

        // Oluşturan kullanıcı
        public string OwnerId { get; set; }

        // Kulüp bilgisi (öğrenci etkinliği ise null)
        public Guid? ClubId { get; set; }
        public string ClubName { get; set; }
        public string ClubInitials { get; set; }

        // Etkileşim istatistikleri
        public int LikeCount { get; set; }
        public int CommentCount { get; set; }
        public int TicketCount { get; set; }

        // Oturum açmış kullanıcıya göre (API isteğinde token varsa doldurulur)
        public bool IsLikedByCurrentUser { get; set; }
        public bool HasTicket { get; set; }
    }

    // Etkinlik oluşturma
    public class CreateEventDto
    {
        public string Title { get; set; }
        public string Description { get; set; }
        public DateTime Date { get; set; }
        public string Location { get; set; }
        public string Address { get; set; }
        public decimal Price { get; set; }
        public int Quota { get; set; }
        public string ImageUrl { get; set; }
        public Guid? CategoryId { get; set; }
        // Kulüp etkinliği için dolu, öğrenci etkinliği için null
        public Guid? ClubId { get; set; }
    }

    // Etkinlik güncelleme
    public class UpdateEventDto
    {
        public string Title { get; set; }
        public string Description { get; set; }
        public DateTime Date { get; set; }
        public string Location { get; set; }
        public string Address { get; set; }
        public decimal Price { get; set; }
        public int Quota { get; set; }
        public string ImageUrl { get; set; }
        public Guid? CategoryId { get; set; }
        public bool IsActive { get; set; }
    }

    // Kısa liste kartı için (ana sayfa grid)
    public class EventListDto
    {
        public Guid Id { get; set; }
        public string Title { get; set; }
        public string OwnerId { get; set; }
        public string ClubName { get; set; }
        public string CategoryName { get; set; }
        public decimal Price { get; set; }
        public DateTime Date { get; set; }
        public string ImageUrl { get; set; }
        public int LikeCount { get; set; }
        public bool IsLikedByCurrentUser { get; set; }
    }
}
