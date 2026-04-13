using System;

namespace CleanArchitecture.Core.DTOs.Comment
{
    public class CommentDto
    {
        public Guid Id { get; set; }
        public string Content { get; set; }
        public DateTime CreatedAt { get; set; }
        public string UserFullName { get; set; }
        public string UserInitials { get; set; }
        public string ApplicationUserId { get; set; }
    }

    public class CreateCommentDto
    {
        public Guid EventId { get; set; }
        public string Content { get; set; }
    }
}
