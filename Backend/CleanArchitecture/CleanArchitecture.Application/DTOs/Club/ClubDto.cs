using System;

namespace CleanArchitecture.Core.DTOs.Club
{
    public class ClubDto
    {
        public Guid Id { get; set; }
        public string Name { get; set; }
        public string Initials { get; set; }
        public string Category { get; set; }
        public string Description { get; set; }
        public string CoverImageUrl { get; set; }
        public string InstagramHandle { get; set; }
        public int FollowerCount { get; set; }
        public int EventCount { get; set; }
        public bool IsFollowedByCurrentUser { get; set; }
    }

    public class CreateClubDto
    {
        public string Name { get; set; }
        public string Initials { get; set; }
        public string Category { get; set; }
        public string Description { get; set; }
        public string CoverImageUrl { get; set; }
        public string InstagramHandle { get; set; }
    }

    // Ana sayfada popüler kulüpler listesi için minimal DTO
    public class ClubListDto
    {
        public Guid Id { get; set; }
        public string Name { get; set; }
        public string Initials { get; set; }
        public string Category { get; set; }
        public int FollowerCount { get; set; }
        public bool IsFollowedByCurrentUser { get; set; }
    }
}
