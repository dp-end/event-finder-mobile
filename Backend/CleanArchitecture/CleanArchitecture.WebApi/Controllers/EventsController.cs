using CleanArchitecture.Application.Entities;
using CleanArchitecture.Core.DTOs.Event;
using CleanArchitecture.Core.Interfaces;
using CleanArchitecture.Infrastructure.Contexts;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;

namespace CleanArchitecture.WebApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EventsController : ControllerBase
    {
        private readonly IEventRepository _eventRepo;
        private readonly ApplicationDbContext _context;

        public EventsController(IEventRepository eventRepo, ApplicationDbContext context)
        {
            _eventRepo = eventRepo;
            _context = context;
        }

        // GET /api/events
        // GET /api/events?query=zeka&category=Teknoloji&freeOnly=true&maxPrice=100&timePeriod=Bu Hafta
        [HttpGet]
        public async Task<IActionResult> GetAll(
            [FromQuery] string query = null,
            [FromQuery] string category = null,
            [FromQuery] bool? freeOnly = null,
            [FromQuery] decimal? maxPrice = null,
            [FromQuery] string timePeriod = null)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

            if (string.IsNullOrWhiteSpace(query) && string.IsNullOrWhiteSpace(category) &&
                freeOnly == null && maxPrice == null && string.IsNullOrWhiteSpace(timePeriod))
            {
                var all = await _eventRepo.GetAllAsync(userId);
                return Ok(all);
            }

            var result = await _eventRepo.SearchAsync(query, category, freeOnly, maxPrice, timePeriod, userId);
            return Ok(result);
        }

        // GET /api/events/{id}
        [HttpGet("{id:guid}")]
        public async Task<IActionResult> GetById(Guid id)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var result = await _eventRepo.GetByIdAsync(id, userId);
            if (result == null) return NotFound();
            return Ok(result);
        }

        // GET /api/events/club/{clubId}
        [HttpGet("club/{clubId:guid}")]
        public async Task<IActionResult> GetByClub(Guid clubId)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var result = await _eventRepo.GetByClubAsync(clubId, userId);
            return Ok(result);
        }

        // POST /api/events
        [HttpPost]
        [Authorize]
        public async Task<IActionResult> Create([FromBody] CreateEventDto dto)
        {
            var ownerId = User.FindFirstValue(ClaimTypes.NameIdentifier);

            // Frontend clubId gönderemediyse, bu kullanıcının admin olduğu kulübü bul
            var resolvedClubId = dto.ClubId;
            if (resolvedClubId == null && ownerId != null)
            {
                // uid claim'i kullanıcı GUID'ini tutar
                var uid = User.FindFirstValue("uid");
                if (uid != null)
                {
                    var adminClub = _context.Clubs.FirstOrDefault(c => c.AdminUserId == uid);
                    resolvedClubId = adminClub?.Id;
                }
            }

            var entity = new Event
            {
                Title = dto.Title,
                Description = dto.Description,
                Date = dto.Date,
                Location = dto.Location,
                Address = dto.Address,
                Price = dto.Price,
                Quota = dto.Quota,
                ImageUrl = dto.ImageUrl,
                CategoryId = dto.CategoryId,
                ClubId = resolvedClubId,
                OwnerId = ownerId,
                IsActive = true
            };

            var created = await _eventRepo.CreateAsync(entity);
            return CreatedAtAction(nameof(GetById), new { id = created.Id }, created);
        }

        // PUT /api/events/{id}
        [HttpPut("{id:guid}")]
        [Authorize]
        public async Task<IActionResult> Update(Guid id, [FromBody] UpdateEventDto dto)
        {
            if (!await _eventRepo.ExistsAsync(id)) return NotFound();

            var entity = new Event
            {
                Title = dto.Title,
                Description = dto.Description,
                Date = dto.Date,
                Location = dto.Location,
                Address = dto.Address,
                Price = dto.Price,
                Quota = dto.Quota,
                ImageUrl = dto.ImageUrl,
                CategoryId = dto.CategoryId,
                IsActive = dto.IsActive
            };

            await _eventRepo.UpdateAsync(id, entity);
            return NoContent();
        }

        // DELETE /api/events/{id}
        [HttpDelete("{id:guid}")]
        [Authorize(Roles = "SuperAdmin,Admin")]
        public async Task<IActionResult> Delete(Guid id)
        {
            if (!await _eventRepo.ExistsAsync(id)) return NotFound();
            await _eventRepo.DeleteAsync(id);
            return NoContent();
        }

        // POST /api/events/{id}/like  — beğen / beğeniyi kaldır (toggle)
        [HttpPost("{id:guid}/like")]
        [Authorize]
        public async Task<IActionResult> Like(Guid id)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (!await _eventRepo.ExistsAsync(id)) return NotFound();

            bool liked = await _eventRepo.LikeAsync(id, userId);
            return Ok(new { liked, message = liked ? "Favorilere eklendi." : "Favorilerden çıkarıldı." });
        }
    }
}
