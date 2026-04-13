using CleanArchitecture.Application.Entities;
using CleanArchitecture.Core.DTOs.Club;
using CleanArchitecture.Core.Interfaces;
using CleanArchitecture.Infrastructure.Contexts;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace CleanArchitecture.Infrastructure.Repositories
{
    public class ClubRepository : IClubRepository
    {
        private readonly ApplicationDbContext _context;

        public ClubRepository(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<ClubListDto>> GetAllAsync(string currentUserId = null)
        {
            var clubs = await _context.Clubs
                .Include(c => c.Followers)
                .Include(c => c.Events)
                .OrderBy(c => c.Name)
                .AsNoTracking()
                .ToListAsync();

            return MapToListDto(clubs, currentUserId);
        }

        public async Task<IEnumerable<ClubListDto>> GetPopularAsync(int count, string currentUserId = null)
        {
            var clubs = await _context.Clubs
                .Include(c => c.Followers)
                .Include(c => c.Events)
                .OrderByDescending(c => c.Followers.Count)
                .Take(count)
                .AsNoTracking()
                .ToListAsync();

            return MapToListDto(clubs, currentUserId);
        }

        public async Task<ClubDto> GetByIdAsync(Guid id, string currentUserId = null)
        {
            var c = await _context.Clubs
                .Include(x => x.Followers)
                .Include(x => x.Events)
                .AsNoTracking()
                .FirstOrDefaultAsync(x => x.Id == id);

            if (c == null) return null;

            return new ClubDto
            {
                Id = c.Id,
                Name = c.Name,
                Initials = c.Initials,
                Category = c.Category,
                Description = c.Description,
                CoverImageUrl = c.CoverImageUrl,
                InstagramHandle = c.InstagramHandle,
                FollowerCount = c.Followers?.Count ?? 0,
                EventCount = c.Events?.Count ?? 0,
                IsFollowedByCurrentUser = currentUserId != null && (c.Followers?.Any(f => f.ApplicationUserId == currentUserId) ?? false)
            };
        }

        public async Task<Club> CreateAsync(Club entity)
        {
            _context.Clubs.Add(entity);
            await _context.SaveChangesAsync();
            return entity;
        }

        public async Task UpdateAsync(Guid id, Club entity)
        {
            var existing = await _context.Clubs.FindAsync(id);
            if (existing == null) return;

            existing.Name = entity.Name;
            existing.Initials = entity.Initials;
            existing.Category = entity.Category;
            existing.Description = entity.Description;
            existing.CoverImageUrl = entity.CoverImageUrl;
            existing.InstagramHandle = entity.InstagramHandle;

            _context.Clubs.Update(existing);
            await _context.SaveChangesAsync();
        }

        public async Task DeleteAsync(Guid id)
        {
            var entity = await _context.Clubs.FindAsync(id);
            if (entity != null)
            {
                _context.Clubs.Remove(entity);
                await _context.SaveChangesAsync();
            }
        }

        public async Task<bool> FollowAsync(Guid clubId, string userId)
        {
            var existing = await _context.ClubFollowers
                .FirstOrDefaultAsync(f => f.ClubId == clubId && f.ApplicationUserId == userId);

            if (existing != null)
            {
                _context.ClubFollowers.Remove(existing);
                await _context.SaveChangesAsync();
                return false; // Takip bırakıldı
            }

            _context.ClubFollowers.Add(new ClubFollower
            {
                ClubId = clubId,
                ApplicationUserId = userId,
                FollowedAt = DateTime.UtcNow
            });
            await _context.SaveChangesAsync();
            return true; // Takip edildi
        }

        public async Task<bool> ExistsAsync(Guid id)
        {
            return await _context.Clubs.AnyAsync(c => c.Id == id);
        }

        private IEnumerable<ClubListDto> MapToListDto(IEnumerable<Club> clubs, string currentUserId)
        {
            return clubs.Select(c => new ClubListDto
            {
                Id = c.Id,
                Name = c.Name,
                Initials = c.Initials,
                Category = c.Category,
                FollowerCount = c.Followers?.Count ?? 0,
                IsFollowedByCurrentUser = currentUserId != null && (c.Followers?.Any(f => f.ApplicationUserId == currentUserId) ?? false)
            });
        }
    }
}
