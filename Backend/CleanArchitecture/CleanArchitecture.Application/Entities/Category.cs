using System;
using System.Collections.Generic;

namespace CleanArchitecture.Application.Entities
{
    public class Category
    {
        public Guid Id { get; set; } = Guid.NewGuid();
        public string Name { get; set; }           // ör: Spor, Teknoloji, Müzik, Sanat
        public string Description { get; set; }
        public string IconName { get; set; }       // Flutter icon adı (ör: sports_basketball)
        public string ColorHex { get; set; }       // UI rengi (ör: #1D4ED8)

        // Bu kategoriye ait etkinlikler
        public ICollection<Event> Events { get; set; }
    }
}
