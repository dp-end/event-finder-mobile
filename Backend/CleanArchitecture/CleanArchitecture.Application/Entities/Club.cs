using System;
using System.Collections.Generic;

namespace CleanArchitecture.Application.Entities
{
    public class Club
    {
        public Guid Id { get; set; } = Guid.NewGuid();
        public string Name { get; set; }
        public string Initials { get; set; } 
        public string Category { get; set; }
        public string Description { get; set; }
        public string CoverImageUrl { get; set; }
        public string InstagramHandle { get; set; }
        
        // Bir kulübün birden fazla etkinliği olabilir (Bire-Çok İlişki)
        public ICollection<Event> Events { get; set; }
    }
}