using System;

namespace CleanArchitecture.Application.Entities
{
    // Bir kullanıcının bir kulübü takip etmesi
    // Composite PK: (ClubId, ApplicationUserId)
    public class ClubFollower
    {
        public Guid ClubId { get; set; }
        public Club Club { get; set; }

        public string ApplicationUserId { get; set; }

        public DateTime FollowedAt { get; set; } = DateTime.UtcNow;
    }
}
