using CleanArchitecture.Application.Entities;
using CleanArchitecture.Core.DTOs.Comment;
using CleanArchitecture.Core.Interfaces;
using CleanArchitecture.Infrastructure.Contexts;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace CleanArchitecture.Infrastructure.Repositories
{
    public class CommentRepository : ICommentRepository
    {
        private readonly ApplicationDbContext _context;

        public CommentRepository(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<CommentDto>> GetByEventAsync(Guid eventId)
        {
            var comments = await _context.Comments
                .Where(c => c.EventId == eventId)
                .OrderByDescending(c => c.CreatedAt)
                .AsNoTracking()
                .ToListAsync();

            return comments.Select(c => new CommentDto
            {
                Id = c.Id,
                Content = c.Content,
                CreatedAt = c.CreatedAt,
                UserFullName = c.UserFullName,
                UserInitials = c.UserInitials,
                ApplicationUserId = c.ApplicationUserId
            });
        }

        public async Task<CommentDto> AddAsync(CreateCommentDto dto, string userId, string userFullName, string userInitials)
        {
            var comment = new Comment
            {
                Id = Guid.NewGuid(),
                EventId = dto.EventId,
                Content = dto.Content,
                ApplicationUserId = userId,
                UserFullName = userFullName,
                UserInitials = userInitials,
                CreatedAt = DateTime.UtcNow
            };

            _context.Comments.Add(comment);
            await _context.SaveChangesAsync();

            return new CommentDto
            {
                Id = comment.Id,
                Content = comment.Content,
                CreatedAt = comment.CreatedAt,
                UserFullName = comment.UserFullName,
                UserInitials = comment.UserInitials,
                ApplicationUserId = comment.ApplicationUserId
            };
        }

        public async Task DeleteAsync(Guid commentId, string userId)
        {
            var comment = await _context.Comments
                .FirstOrDefaultAsync(c => c.Id == commentId && c.ApplicationUserId == userId);

            if (comment != null)
            {
                _context.Comments.Remove(comment);
                await _context.SaveChangesAsync();
            }
        }
    }
}
