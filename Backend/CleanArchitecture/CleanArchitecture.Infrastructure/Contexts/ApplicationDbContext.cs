using CleanArchitecture.Application.Entities;
using CleanArchitecture.Core.Interfaces;
using CleanArchitecture.Infrastructure.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using System;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;

namespace CleanArchitecture.Infrastructure.Contexts
{
    public class ApplicationDbContext : IdentityDbContext<ApplicationUser>
    {
        private readonly IDateTimeService _dateTime;
        private readonly IAuthenticatedUserService _authenticatedUser;

        public ApplicationDbContext(
            DbContextOptions<ApplicationDbContext> options,
            IDateTimeService dateTime,
            IAuthenticatedUserService authenticatedUser) : base(options)
        {
            ChangeTracker.QueryTrackingBehavior = QueryTrackingBehavior.NoTracking;
            _dateTime = dateTime;
            _authenticatedUser = authenticatedUser;
        }

        // ===== TABLOLAR =====
        public DbSet<Category> Categories { get; set; }
        public DbSet<Club> Clubs { get; set; }
        public DbSet<Event> Events { get; set; }
        public DbSet<Ticket> Tickets { get; set; }
        public DbSet<Comment> Comments { get; set; }
        public DbSet<EventLike> EventLikes { get; set; }
        public DbSet<ClubFollower> ClubFollowers { get; set; }
        public DbSet<Notification> Notifications { get; set; }

        public override Task<int> SaveChangesAsync(CancellationToken cancellationToken = default)
        {
            return base.SaveChangesAsync(cancellationToken);
        }

        protected override void OnModelCreating(ModelBuilder builder)
        {
            base.OnModelCreating(builder);

            // -------- Identity tablo adlarını temizle --------
            builder.Entity<ApplicationUser>(e => e.ToTable("User"));
            builder.Entity<IdentityRole>(e => e.ToTable("Role"));
            builder.Entity<IdentityUserRole<string>>(e => e.ToTable("UserRoles"));
            builder.Entity<IdentityUserClaim<string>>(e => e.ToTable("UserClaims"));
            builder.Entity<IdentityUserLogin<string>>(e => e.ToTable("UserLogins"));
            builder.Entity<IdentityRoleClaim<string>>(e => e.ToTable("RoleClaims"));
            builder.Entity<IdentityUserToken<string>>(e => e.ToTable("UserTokens"));

            // -------- Decimal sütunları standartlaştır --------
            foreach (var prop in builder.Model.GetEntityTypes()
                .SelectMany(t => t.GetProperties())
                .Where(p => p.ClrType == typeof(decimal) || p.ClrType == typeof(decimal?)))
            {
                prop.SetColumnType("decimal(18,6)");
            }

            // -------- Category --------
            builder.Entity<Category>(entity =>
            {
                entity.HasKey(c => c.Id);
                entity.Property(c => c.Name).IsRequired().HasMaxLength(100);
                entity.Property(c => c.IconName).HasMaxLength(100);
                entity.Property(c => c.ColorHex).HasMaxLength(20);
            });

            // -------- Club --------
            builder.Entity<Club>(entity =>
            {
                entity.HasKey(c => c.Id);
                entity.Property(c => c.Name).IsRequired().HasMaxLength(200);
                entity.Property(c => c.Initials).HasMaxLength(10);
                entity.Property(c => c.Category).HasMaxLength(100);
                entity.Property(c => c.AdminUserId).HasMaxLength(450);
            });

            // -------- Event --------
            builder.Entity<Event>(entity =>
            {
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Title).IsRequired().HasMaxLength(300);
                entity.Property(e => e.Location).HasMaxLength(500);
                entity.Property(e => e.Address).HasMaxLength(500);
                entity.Property(e => e.OwnerId).HasMaxLength(450);

                // Event → Club (Bire-Çok, opsiyonel: öğrenci etkinliği için null)
                entity.HasOne(e => e.Club)
                    .WithMany(c => c.Events)
                    .HasForeignKey(e => e.ClubId)
                    .IsRequired(false)
                    .OnDelete(DeleteBehavior.SetNull);

                // Event → Category (Bire-Çok, opsiyonel)
                entity.HasOne(e => e.Category)
                    .WithMany(c => c.Events)
                    .HasForeignKey(e => e.CategoryId)
                    .IsRequired(false)
                    .OnDelete(DeleteBehavior.SetNull);
            });

            // -------- Ticket --------
            builder.Entity<Ticket>(entity =>
            {
                entity.HasKey(t => t.Id);
                entity.Property(t => t.QrCode).HasMaxLength(64);
                entity.Property(t => t.TicketNumber).HasMaxLength(50);
                entity.Property(t => t.ApplicationUserId).HasMaxLength(450);

                entity.HasOne(t => t.Event)
                    .WithMany(e => e.Tickets)
                    .HasForeignKey(t => t.EventId)
                    .OnDelete(DeleteBehavior.Cascade);
            });

            // -------- Comment --------
            builder.Entity<Comment>(entity =>
            {
                entity.HasKey(c => c.Id);
                entity.Property(c => c.Content).IsRequired().HasMaxLength(1000);
                entity.Property(c => c.ApplicationUserId).HasMaxLength(450);
                entity.Property(c => c.UserFullName).HasMaxLength(200);
                entity.Property(c => c.UserInitials).HasMaxLength(10);

                entity.HasOne(c => c.Event)
                    .WithMany(e => e.Comments)
                    .HasForeignKey(c => c.EventId)
                    .OnDelete(DeleteBehavior.Cascade);
            });

            // -------- EventLike (composite PK) --------
            builder.Entity<EventLike>(entity =>
            {
                entity.HasKey(l => new { l.EventId, l.ApplicationUserId });
                entity.Property(l => l.ApplicationUserId).HasMaxLength(450);

                entity.HasOne(l => l.Event)
                    .WithMany(e => e.Likes)
                    .HasForeignKey(l => l.EventId)
                    .OnDelete(DeleteBehavior.Cascade);
            });

            // -------- ClubFollower (composite PK) --------
            builder.Entity<ClubFollower>(entity =>
            {
                entity.HasKey(f => new { f.ClubId, f.ApplicationUserId });
                entity.Property(f => f.ApplicationUserId).HasMaxLength(450);

                entity.HasOne(f => f.Club)
                    .WithMany(c => c.Followers)
                    .HasForeignKey(f => f.ClubId)
                    .OnDelete(DeleteBehavior.Cascade);
            });

            // -------- Notification --------
            builder.Entity<Notification>(entity =>
            {
                entity.HasKey(n => n.Id);
                entity.Property(n => n.Title).IsRequired().HasMaxLength(300);
                entity.Property(n => n.Body).HasMaxLength(1000);
                entity.Property(n => n.ApplicationUserId).HasMaxLength(450).IsRequired();
                entity.Property(n => n.Type).HasConversion<int>();

                entity.HasIndex(n => n.ApplicationUserId);  // Kullanıcı bildirimleri hızlı sorgu
            });

            // -------- Seed: Varsayılan Kategoriler --------
            builder.Entity<Category>().HasData(
                new Category { Id = new Guid("11111111-0000-0000-0000-000000000001"), Name = "Spor",       IconName = "sports_basketball", ColorHex = "#EF4444", Description = "Spor etkinlikleri" },
                new Category { Id = new Guid("11111111-0000-0000-0000-000000000002"), Name = "Teknoloji",  IconName = "computer",          ColorHex = "#1D4ED8", Description = "Teknoloji ve yazılım etkinlikleri" },
                new Category { Id = new Guid("11111111-0000-0000-0000-000000000003"), Name = "Müzik",      IconName = "music_note",        ColorHex = "#7C3AED", Description = "Konser ve müzik etkinlikleri" },
                new Category { Id = new Guid("11111111-0000-0000-0000-000000000004"), Name = "Sanat",      IconName = "palette",           ColorHex = "#D97706", Description = "Sanat ve kültür etkinlikleri" },
                new Category { Id = new Guid("11111111-0000-0000-0000-000000000005"), Name = "Kariyer",    IconName = "work",              ColorHex = "#059669", Description = "Kariyer ve girişimcilik etkinlikleri" }
            );
        }
    }
}
