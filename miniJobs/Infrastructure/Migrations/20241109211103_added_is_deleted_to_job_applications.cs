using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class added_is_deleted_to_job_applications : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "state",
                table: "jobs");

            migrationBuilder.AddColumn<bool>(
                name: "is_deleted",
                table: "job_applications",
                type: "bit",
                nullable: false,
                defaultValue: false);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "is_deleted",
                table: "job_applications");

            migrationBuilder.AddColumn<int>(
                name: "state",
                table: "jobs",
                type: "int",
                nullable: false,
                defaultValue: 0);
        }
    }
}
