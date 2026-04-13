using CleanArchitecture.Application.Entities;
using CleanArchitecture.Core.DTOs.Comment;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace CleanArchitecture.Core.Interfaces
{
    public interface ICommentRepository
    {
        Task<IEnumerable<CommentDto>> GetByEventAsync(Guid eventId);
        Task<CommentDto> AddAsync(CreateCommentDto dto, string userId, string userFullName, string userInitials);
        Task DeleteAsync(Guid commentId, string userId);  // Sadece kendi yorumunu silebilir
    }
}
