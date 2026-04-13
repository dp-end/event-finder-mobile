using System;

namespace CleanArchitecture.Core.DTOs.Category
{
    public class CategoryDto
    {
        public Guid Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
        public string IconName { get; set; }
        public string ColorHex { get; set; }
        public int EventCount { get; set; }
    }
}
