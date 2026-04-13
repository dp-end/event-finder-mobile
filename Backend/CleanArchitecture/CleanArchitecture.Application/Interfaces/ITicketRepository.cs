using CleanArchitecture.Application.Entities;
using CleanArchitecture.Core.DTOs.Ticket;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace CleanArchitecture.Core.Interfaces
{
    public interface ITicketRepository
    {
        Task<IEnumerable<TicketDto>> GetUserTicketsAsync(string userId);
        Task<TicketDto> GetByIdAsync(Guid id, string userId);
        Task<TicketDto> PurchaseAsync(Guid eventId, string userId);
        Task<bool> MarkAsUsedAsync(Guid ticketId);          // Kapı giriş kontrolü için
        Task<bool> HasTicketAsync(Guid eventId, string userId);
        Task<int> GetRemainingQuotaAsync(Guid eventId);
    }
}
