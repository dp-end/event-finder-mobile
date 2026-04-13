using CleanArchitecture.Application.Entities;
using CleanArchitecture.Core.DTOs.Club;
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
    public class ClubsController : ControllerBase
    {
        private readonly IClubRepository _clubRepo;

        public ClubsController(IClubRepository clubRepo)
        {
            _clubRepo = clubRepo;
        }

        // GET /api/clubs
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var result = await _clubRepo.GetAllAsync(userId);
            return Ok(result);
        }

        // GET /api/clubs/popular?count=5
        [HttpGet("popular")]
        public async Task<IActionResult> GetPopular([FromQuery] int count = 5)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var result = await _clubRepo.GetPopularAsync(count, userId);
            return Ok(result);
        }

        // GET /api/clubs/{id}
        [HttpGet("{id:guid}")]
        public async Task<IActionResult> GetById(Guid id)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var result = await _clubRepo.GetByIdAsync(id, userId);
            if (result == null) return NotFound();
            return Ok(result);
        }

        // POST /api/clubs
        [HttpPost]
        [Authorize(Roles = "SuperAdmin,Admin")]
        public async Task<IActionResult> Create([FromBody] CreateClubDto dto)
        {
            var entity = new Club
            {
                Name = dto.Name,
                Initials = dto.Initials,
                Category = dto.Category,
                Description = dto.Description,
                CoverImageUrl = dto.CoverImageUrl,
                InstagramHandle = dto.InstagramHandle,
                AdminUserId = User.FindFirstValue(ClaimTypes.NameIdentifier)
            };

            var created = await _clubRepo.CreateAsync(entity);
            return CreatedAtAction(nameof(GetById), new { id = created.Id }, created);
        }

        // PUT /api/clubs/{id}
        [HttpPut("{id:guid}")]
        [Authorize]
        public async Task<IActionResult> Update(Guid id, [FromBody] CreateClubDto dto)
        {
            if (!await _clubRepo.ExistsAsync(id)) return NotFound();

            var entity = new Club
            {
                Name = dto.Name,
                Initials = dto.Initials,
                Category = dto.Category,
                Description = dto.Description,
                CoverImageUrl = dto.CoverImageUrl,
                InstagramHandle = dto.InstagramHandle
            };

            await _clubRepo.UpdateAsync(id, entity);
            return NoContent();
        }

        // DELETE /api/clubs/{id}
        [HttpDelete("{id:guid}")]
        [Authorize(Roles = "SuperAdmin,Admin")]
        public async Task<IActionResult> Delete(Guid id)
        {
            if (!await _clubRepo.ExistsAsync(id)) return NotFound();
            await _clubRepo.DeleteAsync(id);
            return NoContent();
        }

        // POST /api/clubs/{id}/follow  — takip et / bırak (toggle)
        [HttpPost("{id:guid}/follow")]
        [Authorize]
        public async Task<IActionResult> Follow(Guid id)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (!await _clubRepo.ExistsAsync(id)) return NotFound();

            bool following = await _clubRepo.FollowAsync(id, userId);
            return Ok(new { following, message = following ? "Kulüp takip edildi." : "Takip bırakıldı." });
        }
    }
}
