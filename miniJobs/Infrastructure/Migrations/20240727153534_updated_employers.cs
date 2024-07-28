using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class updated_employers : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "street_address_and_number",
                table: "employers",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.CreateIndex(
                name: "IX_users_city_id",
                table: "users",
                column: "city_id");

            migrationBuilder.AddForeignKey(
                name: "FK_users_cities_city_id",
                table: "users",
                column: "city_id",
                principalTable: "cities",
                principalColumn: "id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_users_cities_city_id",
                table: "users");

            migrationBuilder.DropIndex(
                name: "IX_users_city_id",
                table: "users");

            migrationBuilder.DropColumn(
                name: "street_address_and_number",
                table: "employers");
        }
    }
}
