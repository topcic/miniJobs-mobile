using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class removed_cantons : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_cities_cantons_canton_id",
                table: "cities");

            migrationBuilder.DropTable(
                name: "cantons");

            migrationBuilder.DropIndex(
                name: "IX_cities_canton_id",
                table: "cities");

            migrationBuilder.DropColumn(
                name: "canton_id",
                table: "cities");

            migrationBuilder.AddColumn<bool>(
                name: "is_deleted",
                table: "job_types",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<bool>(
                name: "is_deleted",
                table: "cities",
                type: "bit",
                nullable: false,
                defaultValue: false);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "is_deleted",
                table: "job_types");

            migrationBuilder.DropColumn(
                name: "is_deleted",
                table: "cities");

            migrationBuilder.AddColumn<int>(
                name: "canton_id",
                table: "cities",
                type: "int",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "cantons",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    name = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_cantons", x => x.id);
                });

            migrationBuilder.CreateIndex(
                name: "IX_cities_canton_id",
                table: "cities",
                column: "canton_id");

            migrationBuilder.AddForeignKey(
                name: "FK_cities_cantons_canton_id",
                table: "cities",
                column: "canton_id",
                principalTable: "cantons",
                principalColumn: "id");
        }
    }
}
