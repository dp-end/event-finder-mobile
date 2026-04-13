using System;

namespace CleanArchitecture.Application.Entities
{
    // Bir kullanıcının bir etkinliği beğenmesi / favorilere eklemesi
    // Composite PK: (EventId, ApplicationUserId) — bir kullanıcı bir etkinliği tek beğenebilir
    public class EventLike
    {
        public Guid EventId { get; set; }
        public Event Event { get; set; }

        public string ApplicationUserId { get; set; }

        public DateTime LikedAt { get; set; } = DateTime.UtcNow;
    }
}
