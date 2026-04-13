using CleanArchitecture.Application.Entities;
using CleanArchitecture.Core.DTOs.Club;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace CleanArchitecture.Core.Interfaces
{
    public interface IClubRepository
    {
        Task<IEnumerable<ClubListDto>> GetAllAsync(string currentUserId = null);
        Task<IEnumerable<ClubListDto>> GetPopularAsync(int count, string currentUserId = null);
        Task<ClubDto> GetByIdAsync(Guid id, string currentUserId = null);
        Task<Club> CreateAsync(Club entity);
        Task UpdateAsync(Guid id, Club entity);
        Task DeleteAsync(Guid id);
        Task<bool> FollowAsync(Guid clubId, string userId);  // true = takip edildi, false = takip bırakıldı
        Task<bool> ExistsAsync(Guid id);
    }
}
