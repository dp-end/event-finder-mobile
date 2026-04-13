using CleanArchitecture.Application.Entities;
using CleanArchitecture.Core.DTOs.Notification;
using CleanArchitecture.Core.Interfaces;
using CleanArchitecture.Infrastructure.Contexts;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace CleanArchitecture.Infrastructure.Repositories
{
    public class NotificationRepository : INotificationRepository
    {
        private readonly ApplicationDbContext _context;

        public NotificationRepository(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<NotificationDto>> GetUserNotificationsAsync(string userId)
        {
            var notifications = await _context.Notifications
                .Where(n => n.ApplicationUserId == userId)
                .OrderByDescending(n => n.CreatedAt)
                .AsNoTracking()
                .ToListAsync();

            return notifications.Select(n => new NotificationDto
            {
                Id = n.Id,
                Title = n.Title,
                Body = n.Body,
                IsRead = n.IsRead,
                Type = n.Type,
                RelatedEventId = n.RelatedEventId,
                RelatedClubId = n.RelatedClubId,
                CreatedAt = n.CreatedAt
            });
        }

        public async Task<int> GetUnreadCountAsync(string userId)
        {
            return await _context.Notifications
                .CountAsync(n => n.ApplicationUserId == userId && !n.IsRead);
        }

        public async Task MarkAsReadAsync(Guid notificationId, string userId)
        {
            var notification = await _context.Notifications
                .FirstOrDefaultAsync(n => n.Id == notificationId && n.ApplicationUserId == userId);

            if (notification != null)
            {
                notification.IsRead = true;
                _context.Notifications.Update(notification);
                await _context.SaveChangesAsync();
            }
        }

        public async Task MarkAllAsReadAsync(string userId)
        {
            var notifications = await _context.Notifications
                .Where(n => n.ApplicationUserId == userId && !n.IsRead)
                .ToListAsync();

            foreach (var n in notifications)
                n.IsRead = true;

            _context.Notifications.UpdateRange(notifications);
            await _context.SaveChangesAsync();
        }

        public async Task CreateAsync(string userId, string title, string body, NotificationType type,
            Guid? relatedEventId = null, Guid? relatedClubId = null)
        {
            var notification = new Notification
            {
                Id = Guid.NewGuid(),
                ApplicationUserId = userId,
                Title = title,
                Body = body,
                Type = type,
                RelatedEventId = relatedEventId,
                RelatedClubId = relatedClubId,
                CreatedAt = DateTime.UtcNow,
                IsRead = false
            };

            _context.Notifications.Add(notification);
            await _context.SaveChangesAsync();
        }
    }
}
