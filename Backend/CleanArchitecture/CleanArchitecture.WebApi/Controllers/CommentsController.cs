using CleanArchitecture.Core.DTOs.Comment;
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
    public class CommentsController : ControllerBase
    {
        private readonly ICommentRepository _commentRepo;
        private readonly IAuthenticatedUserService _userService;

        public CommentsController(ICommentRepository commentRepo, IAuthenticatedUserService userService)
        {
            _commentRepo = commentRepo;
            _userService = userService;
        }

        // GET /api/comments/event/{eventId}
        [HttpGet("event/{eventId:guid}")]
        public async Task<IActionResult> GetByEvent(Guid eventId)
        {
            var comments = await _commentRepo.GetByEventAsync(eventId);
            return Ok(comments);
        }

        // POST /api/comments
        [HttpPost]
        [Authorize]
        public async Task<IActionResult> Add([FromBody] CreateCommentDto dto)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var fullName = $"{User.FindFirstValue(ClaimTypes.GivenName)} {User.FindFirstValue(ClaimTypes.Surname)}".Trim();
            if (string.IsNullOrWhiteSpace(fullName)) fullName = User.FindFirstValue(ClaimTypes.Name) ?? "Kullanıcı";

            // İlk harf kombinasyonu (AY, ZK vb.)
            var parts = fullName.Split(' ');
            var initials = parts.Length >= 2
                ? $"{parts[0][0]}{parts[^1][0]}".ToUpper()
                : fullName.Substring(0, Math.Min(2, fullName.Length)).ToUpper();

            var comment = await _commentRepo.AddAsync(dto, userId, fullName, initials);
            return Ok(comment);
        }

        // DELETE /api/comments/{id}
        [HttpDelete("{id:guid}")]
        [Authorize]
        public async Task<IActionResult> Delete(Guid id)
        {
            var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            await _commentRepo.DeleteAsync(id, userId);
            return NoContent();
        }
    }
}
