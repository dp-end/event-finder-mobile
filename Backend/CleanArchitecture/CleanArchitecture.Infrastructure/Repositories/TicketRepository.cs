using CleanArchitecture.Application.Entities;
using CleanArchitecture.Core.DTOs.Ticket;
using CleanArchitecture.Core.Interfaces;
using CleanArchitecture.Infrastructure.Contexts;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace CleanArchitecture.Infrastructure.Repositories
{
    public class TicketRepository : ITicketRepository
    {
        private readonly ApplicationDbContext _context;

        public TicketRepository(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<TicketDto>> GetUserTicketsAsync(string userId)
        {
            var tickets = await _context.Tickets
                .Where(t => t.ApplicationUserId == userId)
                .Include(t => t.Event)
                    .ThenInclude(e => e.Club)
                .OrderByDescending(t => t.PurchaseDate)
                .AsNoTracking()
                .ToListAsync();

            return tickets.Select(MapToDto);
        }

        public async Task<TicketDto> GetByIdAsync(Guid id, string userId)
        {
            var ticket = await _context.Tickets
                .Where(t => t.Id == id && t.ApplicationUserId == userId)
                .Include(t => t.Event)
                    .ThenInclude(e => e.Club)
                .AsNoTracking()
                .FirstOrDefaultAsync();

            return ticket == null ? null : MapToDto(ticket);
        }

        public async Task<TicketDto> PurchaseAsync(Guid eventId, string userId)
        {
            // Kontenjan kontrolü
            var eventEntity = await _context.Events
                .Include(e => e.Tickets)
                .FirstOrDefaultAsync(e => e.Id == eventId && e.IsActive);

            if (eventEntity == null)
                throw new InvalidOperationException("Etkinlik bulunamadı veya aktif değil.");

            if (eventEntity.Tickets.Count >= eventEntity.Quota)
                throw new InvalidOperationException("Kontenjan doldu.");

            // Zaten bilet aldı mı?
            if (eventEntity.Tickets.Any(t => t.ApplicationUserId == userId))
                throw new InvalidOperationException("Bu etkinlik için zaten biletiniz var.");

            var ticketNumber = $"TKT-{DateTime.UtcNow:yyyyMMdd}-{Guid.NewGuid().ToString("N").Substring(0, 6).ToUpper()}";

            var ticket = new Ticket
            {
                Id = Guid.NewGuid(),
                EventId = eventId,
                ApplicationUserId = userId,
                PurchaseDate = DateTime.UtcNow,
                QrCode = Guid.NewGuid().ToString("N"),
                TicketNumber = ticketNumber,
                IsUsed = false
            };

            _context.Tickets.Add(ticket);
            await _context.SaveChangesAsync();

            // Detaylarla geri döndür
            return await GetByIdAsync(ticket.Id, userId);
        }

        public async Task<bool> MarkAsUsedAsync(Guid ticketId)
        {
            var ticket = await _context.Tickets.FindAsync(ticketId);
            if (ticket == null || ticket.IsUsed) return false;

            ticket.IsUsed = true;
            _context.Tickets.Update(ticket);
            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> HasTicketAsync(Guid eventId, string userId)
        {
            return await _context.Tickets
                .AnyAsync(t => t.EventId == eventId && t.ApplicationUserId == userId);
        }

        public async Task<int> GetRemainingQuotaAsync(Guid eventId)
        {
            var eventEntity = await _context.Events
                .Include(e => e.Tickets)
                .AsNoTracking()
                .FirstOrDefaultAsync(e => e.Id == eventId);

            if (eventEntity == null) return 0;
            return eventEntity.Quota - (eventEntity.Tickets?.Count ?? 0);
        }

        private TicketDto MapToDto(Ticket t) => new TicketDto
        {
            Id = t.Id,
            TicketNumber = t.TicketNumber,
            QrCode = t.QrCode,
            PurchaseDate = t.PurchaseDate,
            IsUsed = t.IsUsed,
            EventId = t.EventId,
            EventTitle = t.Event?.Title,
            EventDate = t.Event?.Date ?? DateTime.MinValue,
            EventLocation = t.Event?.Location,
            EventImageUrl = t.Event?.ImageUrl,
            ClubName = t.Event?.Club?.Name
        };
    }
}
