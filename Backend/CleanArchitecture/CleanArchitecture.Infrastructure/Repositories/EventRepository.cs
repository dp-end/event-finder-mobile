using CleanArchitecture.Application.Entities;
using CleanArchitecture.Core.DTOs.Event;
using CleanArchitecture.Core.Interfaces;
using CleanArchitecture.Infrastructure.Contexts;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace CleanArchitecture.Infrastructure.Repositories
{
    public class EventRepository : IEventRepository
    {
        private readonly ApplicationDbContext _context;

        public EventRepository(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<EventListDto>> GetAllAsync(string currentUserId = null)
        {
            var query = _context.Events
                .Where(e => e.IsActive)
                .Include(e => e.Club)
                .Include(e => e.Category)
                .Include(e => e.Likes)
                .Include(e => e.Tickets)
                .OrderBy(e => e.Date)
                .AsNoTracking();

            return await MapToListDto(query, currentUserId);
        }

        public async Task<IEnumerable<EventListDto>> SearchAsync(
            string query, string categoryName, bool? freeOnly, decimal? maxPrice, string timePeriod, string currentUserId = null)
        {
            var now = DateTime.UtcNow;

            var dbQuery = _context.Events
                .Where(e => e.IsActive)
                .Include(e => e.Club)
                .Include(e => e.Category)
                .Include(e => e.Likes)
                .Include(e => e.Tickets)
                .AsNoTracking();

            if (!string.IsNullOrWhiteSpace(query))
                dbQuery = dbQuery.Where(e =>
                    e.Title.Contains(query) || e.Club.Name.Contains(query) || e.Description.Contains(query));

            if (!string.IsNullOrWhiteSpace(categoryName) && categoryName != "Tümü")
                dbQuery = dbQuery.Where(e => e.Category.Name == categoryName);

            if (freeOnly == true)
                dbQuery = dbQuery.Where(e => e.Price == 0);
            else if (maxPrice.HasValue)
                dbQuery = dbQuery.Where(e => e.Price <= maxPrice.Value);

            if (!string.IsNullOrWhiteSpace(timePeriod) && timePeriod != "Tümü")
            {
                dbQuery = timePeriod switch
                {
                    "Bugün" => dbQuery.Where(e => e.Date.Date == now.Date),
                    "Bu Hafta" => dbQuery.Where(e => e.Date >= now && e.Date <= now.AddDays(7)),
                    "Bu Ay" => dbQuery.Where(e => e.Date.Year == now.Year && e.Date.Month == now.Month),
                    _ => dbQuery
                };
            }

            dbQuery = dbQuery.OrderBy(e => e.Date);
            return await MapToListDto(dbQuery, currentUserId);
        }

        public async Task<EventDto> GetByIdAsync(Guid id, string currentUserId = null)
        {
            var e = await _context.Events
                .Include(x => x.Club)
                .Include(x => x.Category)
                .Include(x => x.Likes)
                .Include(x => x.Tickets)
                .Include(x => x.Comments)
                .AsNoTracking()
                .FirstOrDefaultAsync(x => x.Id == id);

            if (e == null) return null;

            return new EventDto
            {
                Id = e.Id,
                Title = e.Title,
                Description = e.Description,
                Date = e.Date,
                Location = e.Location,
                Address = e.Address,
                Price = e.Price,
                Quota = e.Quota,
                RemainingQuota = e.Quota - (e.Tickets?.Count ?? 0),
                ImageUrl = e.ImageUrl,
                IsActive = e.IsActive,
                OwnerId = e.OwnerId,
                CategoryId = e.CategoryId,
                CategoryName = e.Category?.Name,
                ClubId = e.ClubId,
                ClubName = e.Club?.Name ?? "Bireysel Etkinlik",
                ClubInitials = e.Club?.Initials ?? "BE",
                LikeCount = e.Likes?.Count ?? 0,
                CommentCount = e.Comments?.Count ?? 0,
                TicketCount = e.Tickets?.Count ?? 0,
                IsLikedByCurrentUser = currentUserId != null && (e.Likes?.Any(l => l.ApplicationUserId == currentUserId) ?? false),
                HasTicket = currentUserId != null && (e.Tickets?.Any(t => t.ApplicationUserId == currentUserId) ?? false)
            };
        }

        public async Task<IEnumerable<EventListDto>> GetByClubAsync(Guid clubId, string currentUserId = null)
        {
            var query = _context.Events
                .Where(e => e.ClubId == clubId && e.IsActive)
                .Include(e => e.Club)
                .Include(e => e.Category)
                .Include(e => e.Likes)
                .Include(e => e.Tickets)
                .OrderBy(e => e.Date)
                .AsNoTracking();

            return await MapToListDto(query, currentUserId);
        }

        public async Task<Event> CreateAsync(Event entity)
        {
            _context.Events.Add(entity);
            await _context.SaveChangesAsync();
            return entity;
        }

        public async Task UpdateAsync(Guid id, Event entity)
        {
            var existing = await _context.Events.FindAsync(id);
            if (existing == null) return;

            existing.Title = entity.Title;
            existing.Description = entity.Description;
            existing.Date = entity.Date;
            existing.Location = entity.Location;
            existing.Address = entity.Address;
            existing.Price = entity.Price;
            existing.Quota = entity.Quota;
            existing.ImageUrl = entity.ImageUrl;
            existing.CategoryId = entity.CategoryId;
            existing.IsActive = entity.IsActive;

            _context.Events.Update(existing);
            await _context.SaveChangesAsync();
        }

        public async Task DeleteAsync(Guid id)
        {
            var entity = await _context.Events.FindAsync(id);
            if (entity != null)
            {
                _context.Events.Remove(entity);
                await _context.SaveChangesAsync();
            }
        }

        public async Task<bool> LikeAsync(Guid eventId, string userId)
        {
            var existing = await _context.EventLikes
                .FirstOrDefaultAsync(l => l.EventId == eventId && l.ApplicationUserId == userId);

            if (existing != null)
            {
                // Beğeniyi kaldır (toggle)
                _context.EventLikes.Remove(existing);
                await _context.SaveChangesAsync();
                return false;
            }

            _context.EventLikes.Add(new EventLike
            {
                EventId = eventId,
                ApplicationUserId = userId,
                LikedAt = DateTime.UtcNow
            });
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> ExistsAsync(Guid id)
        {
            return await _context.Events.AnyAsync(e => e.Id == id);
        }

        // --- Yardımcı: IQueryable → List<EventListDto> dönüştürücü ---
        private async Task<List<EventListDto>> MapToListDto(IQueryable<Event> query, string currentUserId)
        {
            var events = await query.ToListAsync();
            return events.Select(e => new EventListDto
            {
                Id = e.Id,
                Title = e.Title,
                OwnerId = e.OwnerId,
                // Kulüp yoksa (öğrenci etkinliği) "Bireysel Etkinlik" yaz
                ClubName = e.Club?.Name ?? "Bireysel Etkinlik",
                CategoryName = e.Category?.Name,
                Price = e.Price,
                Date = e.Date,
                ImageUrl = e.ImageUrl,
                LikeCount = e.Likes?.Count ?? 0,
                IsLikedByCurrentUser = currentUserId != null && (e.Likes?.Any(l => l.ApplicationUserId == currentUserId) ?? false)
            }).ToList();
        }
    }
}
