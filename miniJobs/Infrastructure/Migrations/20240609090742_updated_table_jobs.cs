using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class updated_table_jobs : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "applications_end_to",
                table: "jobs");

            migrationBuilder.AddColumn<int>(
                name: "applications_duration",
                table: "jobs",
                type: "int",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "applications_duration",
                table: "jobs");

            migrationBuilder.AddColumn<DateTime>(
                name: "applications_end_to",
                table: "jobs",
                type: "datetime2",
                nullable: true);
        }
    }
}
