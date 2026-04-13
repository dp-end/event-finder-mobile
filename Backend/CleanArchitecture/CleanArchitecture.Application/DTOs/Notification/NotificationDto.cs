using System;
using CleanArchitecture.Application.Entities;

namespace CleanArchitecture.Core.DTOs.Notification
{
    public class NotificationDto
    {
        public Guid Id { get; set; }
        public string Title { get; set; }
        public string Body { get; set; }
        public bool IsRead { get; set; }
        public NotificationType Type { get; set; }
        public Guid? RelatedEventId { get; set; }
        public Guid? RelatedClubId { get; set; }
        public DateTime CreatedAt { get; set; }
    }
}
