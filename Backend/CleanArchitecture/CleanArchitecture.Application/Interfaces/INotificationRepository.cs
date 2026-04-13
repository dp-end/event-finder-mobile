using CleanArchitecture.Application.Entities;
using CleanArchitecture.Core.DTOs.Notification;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace CleanArchitecture.Core.Interfaces
{
    public interface INotificationRepository
    {
        Task<IEnumerable<NotificationDto>> GetUserNotificationsAsync(string userId);
        Task<int> GetUnreadCountAsync(string userId);
        Task MarkAsReadAsync(Guid notificationId, string userId);
        Task MarkAllAsReadAsync(string userId);
        Task CreateAsync(string userId, string title, string body, NotificationType type, Guid? relatedEventId = null, Guid? relatedClubId = null);
    }
}
