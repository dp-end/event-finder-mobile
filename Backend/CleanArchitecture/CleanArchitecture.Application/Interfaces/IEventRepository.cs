using CleanArchitecture.Application.Entities;
using CleanArchitecture.Core.DTOs.Event;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace CleanArchitecture.Core.Interfaces
{
    public interface IEventRepository
    {
        Task<IEnumerable<EventListDto>> GetAllAsync(string currentUserId = null);
        Task<IEnumerable<EventListDto>> SearchAsync(string query, string categoryName, bool? freeOnly, decimal? maxPrice, string timePeriod, string currentUserId = null);
        Task<EventDto> GetByIdAsync(Guid id, string currentUserId = null);
        Task<IEnumerable<EventListDto>> GetByClubAsync(Guid clubId, string currentUserId = null);
        Task<Event> CreateAsync(Event entity);
        Task UpdateAsync(Guid id, Event entity);
        Task DeleteAsync(Guid id);
        Task<bool> LikeAsync(Guid eventId, string userId);    // true = beğenildi, false = beğeni kaldırıldı
        Task<bool> ExistsAsync(Guid id);
    }
}
