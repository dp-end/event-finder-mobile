using System;
using System.Collections.Generic;

namespace CleanArchitecture.Application.Entities
{
    public class Event
    {
        public Guid Id { get; set; } = Guid.NewGuid();
        public string Title { get; set; }
        public string Description { get; set; }
        public DateTime Date { get; set; }
        public string Location { get; set; }
        public decimal Price { get; set; } 
        public int Quota { get; set; } 
        public string ImageUrl { get; set; }

        // İlişkiler (Foreign Keys)
        public Guid ClubId { get; set; }
        public Club Club { get; set; } // Bu etkinliği düzenleyen kulüp
        
        // Bu etkinliğe kesilen biletler
        public ICollection<Ticket> Tickets { get; set; }
    }
}