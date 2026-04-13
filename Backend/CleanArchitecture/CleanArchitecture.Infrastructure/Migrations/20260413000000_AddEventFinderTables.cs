using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace CleanArchitecture.Infrastructure.Migrations
{
    /// <summary>
    /// Migration: Yeni tablolar eklendi
    ///   - Categories  : Etkinlik kategorileri (Spor, Teknoloji, Müzik, Sanat, Kariyer) + 5 seed satırı
    ///   - Comments    : Etkinliklere yapılan kullanıcı yorumları
    ///   - EventLikes  : Kullanıcı beğenileri (composite PK)
    ///   - ClubFollowers: Kulüp takipçileri (composite PK)
    ///   - Notifications: Kullanıcı bildirimleri
    ///
    /// Mevcut tablolarda değişiklikler:
    ///   - Events     : CategoryId (FK), Address, IsActive sütunları eklendi
    ///   - Tickets    : QrCode, IsUsed, TicketNumber sütunları eklendi
    ///   - Clubs      : AdminUserId sütunu eklendi
    ///   - User (AspNetUsers): ProfileImageUrl sütunu eklendi
    /// </summary>
    public partial class AddEventFinderTables : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // ================================================================
            // 1. CATEGORIES tablosu
            // ================================================================
            migrationBuilder.CreateTable(
                name: "Categories",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "char(36)", nullable: false, collation: "ascii_general_ci"),
                    Name = table.Column<string>(type: "varchar(100)", maxLength: 100, nullable: false)
                        .Annotation("MySql:CharSet", "utf8mb4"),
                    Description = table.Column<string>(type: "longtext", nullable: true)
                        .Annotation("MySql:CharSet", "utf8mb4"),
                    IconName = table.Column<string>(type: "varchar(100)", maxLength: 100, nullable: true)
                        .Annotation("MySql:CharSet", "utf8mb4"),
                    ColorHex = table.Column<string>(type: "varchar(20)", maxLength: 20, nullable: true)
                        .Annotation("MySql:CharSet", "utf8mb4")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Categories", x => x.Id);
                })
                .Annotation("MySql:CharSet", "utf8mb4");

            // ================================================================
            // 2. Mevcut EVENTS tablosuna sütun ekle
            // ================================================================
            migrationBuilder.AddColumn<Guid>(
                name: "CategoryId",
                table: "Events",
                type: "char(36)",
                nullable: true,
                collation: "ascii_general_ci");

            migrationBuilder.AddColumn<string>(
                name: "Address",
                table: "Events",
                type: "varchar(500)",
                maxLength: 500,
                nullable: true)
                .Annotation("MySql:CharSet", "utf8mb4");

            migrationBuilder.AddColumn<bool>(
                name: "IsActive",
                table: "Events",
                type: "tinyint(1)",
                nullable: false,
                defaultValue: true);

            migrationBuilder.CreateIndex(
                name: "IX_Events_CategoryId",
                table: "Events",
                column: "CategoryId");

            migrationBuilder.AddForeignKey(
                name: "FK_Events_Categories_CategoryId",
                table: "Events",
                column: "CategoryId",
                principalTable: "Categories",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);

            // ================================================================
            // 3. Mevcut TICKETS tablosuna sütun ekle
            // ================================================================
            migrationBuilder.AddColumn<string>(
                name: "QrCode",
                table: "Tickets",
                type: "varchar(64)",
                maxLength: 64,
                nullable: true)
                .Annotation("MySql:CharSet", "utf8mb4");

            migrationBuilder.AddColumn<bool>(
                name: "IsUsed",
                table: "Tickets",
                type: "tinyint(1)",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<string>(
                name: "TicketNumber",
                table: "Tickets",
                type: "varchar(50)",
                maxLength: 50,
                nullable: true)
                .Annotation("MySql:CharSet", "utf8mb4");

            // ================================================================
            // 4. Mevcut CLUBS tablosuna sütun ekle
            // ================================================================
            migrationBuilder.AddColumn<string>(
                name: "AdminUserId",
                table: "Clubs",
                type: "varchar(450)",
                maxLength: 450,
                nullable: true)
                .Annotation("MySql:CharSet", "utf8mb4");

            // ================================================================
            // 5. Mevcut USER (AspNetUsers) tablosuna sütun ekle
            // ================================================================
            migrationBuilder.AddColumn<string>(
                name: "ProfileImageUrl",
                table: "User",
                type: "longtext",
                nullable: true)
                .Annotation("MySql:CharSet", "utf8mb4");

            // ================================================================
            // 6. COMMENTS tablosu
            // ================================================================
            migrationBuilder.CreateTable(
                name: "Comments",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "char(36)", nullable: false, collation: "ascii_general_ci"),
                    Content = table.Column<string>(type: "varchar(1000)", maxLength: 1000, nullable: false)
                        .Annotation("MySql:CharSet", "utf8mb4"),
                    CreatedAt = table.Column<DateTime>(type: "datetime(6)", nullable: false),
                    EventId = table.Column<Guid>(type: "char(36)", nullable: false, collation: "ascii_general_ci"),
                    ApplicationUserId = table.Column<string>(type: "varchar(450)", maxLength: 450, nullable: true)
                        .Annotation("MySql:CharSet", "utf8mb4"),
                    UserFullName = table.Column<string>(type: "varchar(200)", maxLength: 200, nullable: true)
                        .Annotation("MySql:CharSet", "utf8mb4"),
                    UserInitials = table.Column<string>(type: "varchar(10)", maxLength: 10, nullable: true)
                        .Annotation("MySql:CharSet", "utf8mb4")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Comments", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Comments_Events_EventId",
                        column: x => x.EventId,
                        principalTable: "Events",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                })
                .Annotation("MySql:CharSet", "utf8mb4");

            migrationBuilder.CreateIndex(
                name: "IX_Comments_EventId",
                table: "Comments",
                column: "EventId");

            // ================================================================
            // 7. EVENTLIKES tablosu (composite PK)
            // ================================================================
            migrationBuilder.CreateTable(
                name: "EventLikes",
                columns: table => new
                {
                    EventId = table.Column<Guid>(type: "char(36)", nullable: false, collation: "ascii_general_ci"),
                    ApplicationUserId = table.Column<string>(type: "varchar(450)", maxLength: 450, nullable: false)
                        .Annotation("MySql:CharSet", "utf8mb4"),
                    LikedAt = table.Column<DateTime>(type: "datetime(6)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_EventLikes", x => new { x.EventId, x.ApplicationUserId });
                    table.ForeignKey(
                        name: "FK_EventLikes_Events_EventId",
                        column: x => x.EventId,
                        principalTable: "Events",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                })
                .Annotation("MySql:CharSet", "utf8mb4");

            // ================================================================
            // 8. CLUBFOLLOWERS tablosu (composite PK)
            // ================================================================
            migrationBuilder.CreateTable(
                name: "ClubFollowers",
                columns: table => new
                {
                    ClubId = table.Column<Guid>(type: "char(36)", nullable: false, collation: "ascii_general_ci"),
                    ApplicationUserId = table.Column<string>(type: "varchar(450)", maxLength: 450, nullable: false)
                        .Annotation("MySql:CharSet", "utf8mb4"),
                    FollowedAt = table.Column<DateTime>(type: "datetime(6)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ClubFollowers", x => new { x.ClubId, x.ApplicationUserId });
                    table.ForeignKey(
                        name: "FK_ClubFollowers_Clubs_ClubId",
                        column: x => x.ClubId,
                        principalTable: "Clubs",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                })
                .Annotation("MySql:CharSet", "utf8mb4");

            // ================================================================
            // 9. NOTIFICATIONS tablosu
            // ================================================================
            migrationBuilder.CreateTable(
                name: "Notifications",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "char(36)", nullable: false, collation: "ascii_general_ci"),
                    Title = table.Column<string>(type: "varchar(300)", maxLength: 300, nullable: false)
                        .Annotation("MySql:CharSet", "utf8mb4"),
                    Body = table.Column<string>(type: "varchar(1000)", maxLength: 1000, nullable: true)
                        .Annotation("MySql:CharSet", "utf8mb4"),
                    IsRead = table.Column<bool>(type: "tinyint(1)", nullable: false, defaultValue: false),
                    Type = table.Column<int>(type: "int", nullable: false, defaultValue: 6),
                    RelatedEventId = table.Column<Guid>(type: "char(36)", nullable: true, collation: "ascii_general_ci"),
                    RelatedClubId = table.Column<Guid>(type: "char(36)", nullable: true, collation: "ascii_general_ci"),
                    CreatedAt = table.Column<DateTime>(type: "datetime(6)", nullable: false),
                    ApplicationUserId = table.Column<string>(type: "varchar(450)", maxLength: 450, nullable: false)
                        .Annotation("MySql:CharSet", "utf8mb4")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Notifications", x => x.Id);
                })
                .Annotation("MySql:CharSet", "utf8mb4");

            migrationBuilder.CreateIndex(
                name: "IX_Notifications_ApplicationUserId",
                table: "Notifications",
                column: "ApplicationUserId");

            // ================================================================
            // 10. Seed: Varsayılan Kategoriler
            // ================================================================
            migrationBuilder.InsertData(
                table: "Categories",
                columns: new[] { "Id", "Name", "Description", "IconName", "ColorHex" },
                values: new object[,]
                {
                    { new Guid("11111111-0000-0000-0000-000000000001"), "Spor",      "Spor etkinlikleri",                    "sports_basketball", "#EF4444" },
                    { new Guid("11111111-0000-0000-0000-000000000002"), "Teknoloji", "Teknoloji ve yazılım etkinlikleri",    "computer",          "#1D4ED8" },
                    { new Guid("11111111-0000-0000-0000-000000000003"), "Müzik",     "Konser ve müzik etkinlikleri",         "music_note",        "#7C3AED" },
                    { new Guid("11111111-0000-0000-0000-000000000004"), "Sanat",     "Sanat ve kültür etkinlikleri",         "palette",           "#D97706" },
                    { new Guid("11111111-0000-0000-0000-000000000005"), "Kariyer",   "Kariyer ve girişimcilik etkinlikleri", "work",              "#059669" }
                });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            // Seed verisini sil
            migrationBuilder.DeleteData(table: "Categories", keyColumn: "Id", keyValues: new object[]
            {
                new Guid("11111111-0000-0000-0000-000000000001"),
                new Guid("11111111-0000-0000-0000-000000000002"),
                new Guid("11111111-0000-0000-0000-000000000003"),
                new Guid("11111111-0000-0000-0000-000000000004"),
                new Guid("11111111-0000-0000-0000-000000000005")
            });

            // Yeni tabloları kaldır
            migrationBuilder.DropTable(name: "Notifications");
            migrationBuilder.DropTable(name: "ClubFollowers");
            migrationBuilder.DropTable(name: "EventLikes");
            migrationBuilder.DropTable(name: "Comments");

            // Events FK'yi kaldır
            migrationBuilder.DropForeignKey(name: "FK_Events_Categories_CategoryId", table: "Events");
            migrationBuilder.DropIndex(name: "IX_Events_CategoryId", table: "Events");
            migrationBuilder.DropColumn(name: "CategoryId", table: "Events");
            migrationBuilder.DropColumn(name: "Address", table: "Events");
            migrationBuilder.DropColumn(name: "IsActive", table: "Events");

            // Tickets sütunlarını kaldır
            migrationBuilder.DropColumn(name: "QrCode", table: "Tickets");
            migrationBuilder.DropColumn(name: "IsUsed", table: "Tickets");
            migrationBuilder.DropColumn(name: "TicketNumber", table: "Tickets");

            // Clubs sütununu kaldır
            migrationBuilder.DropColumn(name: "AdminUserId", table: "Clubs");

            // User sütununu kaldır
            migrationBuilder.DropColumn(name: "ProfileImageUrl", table: "User");

            // Categories tablosunu kaldır
            migrationBuilder.DropTable(name: "Categories");
        }
    }
}
