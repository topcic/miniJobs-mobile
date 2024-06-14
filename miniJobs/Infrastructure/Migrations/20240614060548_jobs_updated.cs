using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class jobs_updated : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateIndex(
                name: "IX_jobs_city_id",
                table: "jobs",
                column: "city_id");

            migrationBuilder.AddForeignKey(
                name: "FK_jobs_cities_city_id",
                table: "jobs",
                column: "city_id",
                principalTable: "cities",
                principalColumn: "id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_jobs_cities_city_id",
                table: "jobs");

            migrationBuilder.DropIndex(
                name: "IX_jobs_city_id",
                table: "jobs");
        }
    }
}
