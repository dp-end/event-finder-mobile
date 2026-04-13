using CleanArchitecture.Core.DTOs.Ticket;
using CleanArchitecture.Core.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Security.Claims;
using System.Threading.Tasks;

namespace CleanArchitecture.WebApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class TicketsController : ControllerBase
    {
        private readonly ITicketRepository _ticketRepo;
        private readonly INotificationRepository _notificationRepo;

        public TicketsController(ITicketRepository ticketRepo, INotificationRepository notificationRepo)
        {
            _ticketRepo = ticketRepo;
            _notificationRepo = notificationRepo;
        }

        // GET /api/tickets  — oturum açmış kullanıcının biletleri
        [HttpGet]
        public async Task<IActionResult> GetMyTickets()
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var tickets = await _ticketRepo.GetUserTicketsAsync(userId);
            return Ok(tickets);
        }

        // GET /api/tickets/{id}
        [HttpGet("{id:guid}")]
        public async Task<IActionResult> GetById(Guid id)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var ticket = await _ticketRepo.GetByIdAsync(id, userId);
            if (ticket == null) return NotFound();
            return Ok(ticket);
        }

        // POST /api/tickets/purchase
        [HttpPost("purchase")]
        public async Task<IActionResult> Purchase([FromBody] PurchaseTicketDto dto)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

            try
            {
                var ticket = await _ticketRepo.PurchaseAsync(dto.EventId, userId);

                // Bilet satın alındıktan sonra kullanıcıya bildirim gönder
                await _notificationRepo.CreateAsync(
                    userId,
                    "Biletiniz Hazır!",
                    $"'{ticket.EventTitle}' etkinliği için biletiniz başarıyla oluşturuldu. Bilet No: {ticket.TicketNumber}",
                    Application.Entities.NotificationType.TicketPurchased,
                    relatedEventId: ticket.EventId
                );

                return Ok(ticket);
            }
            catch (InvalidOperationException ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        // GET /api/tickets/check/{eventId}  — kullanıcı bu etkinlik için bilet aldı mı?
        [HttpGet("check/{eventId:guid}")]
        public async Task<IActionResult> CheckTicket(Guid eventId)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var hasTicket = await _ticketRepo.HasTicketAsync(eventId, userId);
            var remaining = await _ticketRepo.GetRemainingQuotaAsync(eventId);
            return Ok(new { hasTicket, remainingQuota = remaining });
        }

        // POST /api/tickets/{id}/use  — kapı girişi (QR tarama sonrası)
        [HttpPost("{id:guid}/use")]
        [Authorize(Roles = "SuperAdmin,Admin")]
        public async Task<IActionResult> MarkAsUsed(Guid id)
        {
            var success = await _ticketRepo.MarkAsUsedAsync(id);
            if (!success) return BadRequest(new { message = "Bilet bulunamadı veya zaten kullanılmış." });
            return Ok(new { message = "Bilet kullanıldı olarak işaretlendi." });
        }
    }
}
