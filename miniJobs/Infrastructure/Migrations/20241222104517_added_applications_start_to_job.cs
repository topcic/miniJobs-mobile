using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class added_applications_start_to_job : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "completed_with_applicants",
                table: "jobs");

            migrationBuilder.AddColumn<DateTime>(
                name: "applications_start",
                table: "jobs",
                type: "datetime2",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "applications_start",
                table: "jobs");

            migrationBuilder.AddColumn<bool>(
                name: "completed_with_applicants",
                table: "jobs",
                type: "bit",
                nullable: false,
                defaultValue: false);
        }
    }
}
