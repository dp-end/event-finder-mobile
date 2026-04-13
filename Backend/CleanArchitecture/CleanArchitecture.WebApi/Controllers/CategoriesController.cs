using CleanArchitecture.Application.Entities;
using CleanArchitecture.Core.DTOs.Category;
using CleanArchitecture.Infrastructure.Contexts;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Linq;
using System.Threading.Tasks;

namespace CleanArchitecture.WebApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CategoriesController : ControllerBase
    {
        private readonly ApplicationDbContext _context;

        public CategoriesController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET /api/categories
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var categories = await _context.Categories
                .Include(c => c.Events)
                .AsNoTracking()
                .ToListAsync();

            var result = categories.Select(c => new CategoryDto
            {
                Id = c.Id,
                Name = c.Name,
                Description = c.Description,
                IconName = c.IconName,
                ColorHex = c.ColorHex,
                EventCount = c.Events?.Count(e => e.IsActive) ?? 0
            });

            return Ok(result);
        }

        // GET /api/categories/{id}
        [HttpGet("{id:guid}")]
        public async Task<IActionResult> GetById(Guid id)
        {
            var c = await _context.Categories
                .Include(x => x.Events)
                .AsNoTracking()
                .FirstOrDefaultAsync(x => x.Id == id);

            if (c == null) return NotFound();

            return Ok(new CategoryDto
            {
                Id = c.Id,
                Name = c.Name,
                Description = c.Description,
                IconName = c.IconName,
                ColorHex = c.ColorHex,
                EventCount = c.Events?.Count(e => e.IsActive) ?? 0
            });
        }

        // POST /api/categories
        [HttpPost]
        [Authorize(Roles = "SuperAdmin,Admin")]
        public async Task<IActionResult> Create([FromBody] CategoryDto dto)
        {
            var category = new Category
            {
                Id = Guid.NewGuid(),
                Name = dto.Name,
                Description = dto.Description,
                IconName = dto.IconName,
                ColorHex = dto.ColorHex
            };

            _context.Categories.Add(category);
            await _context.SaveChangesAsync();
            dto.Id = category.Id;
            return CreatedAtAction(nameof(GetById), new { id = category.Id }, dto);
        }
    }
}
