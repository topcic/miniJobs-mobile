using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class auth_codes_type : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_job_recommendation_cites_cities_city_id",
                table: "job_recommendation_cites");

            migrationBuilder.DropForeignKey(
                name: "FK_job_recommendation_job_types_job_types_job_type_id",
                table: "job_recommendation_job_types");

            migrationBuilder.AddForeignKey(
                name: "FK_job_recommendation_cites_cities_city_id",
                table: "job_recommendation_cites",
                column: "city_id",
                principalTable: "cities",
                principalColumn: "id",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_job_recommendation_job_types_job_types_job_type_id",
                table: "job_recommendation_job_types",
                column: "job_type_id",
                principalTable: "job_types",
                principalColumn: "id",
                onDelete: ReferentialAction.Restrict);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_job_recommendation_cites_cities_city_id",
                table: "job_recommendation_cites");

            migrationBuilder.DropForeignKey(
                name: "FK_job_recommendation_job_types_job_types_job_type_id",
                table: "job_recommendation_job_types");

            migrationBuilder.AddForeignKey(
                name: "FK_job_recommendation_cites_cities_city_id",
                table: "job_recommendation_cites",
                column: "city_id",
                principalTable: "cities",
                principalColumn: "id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_job_recommendation_job_types_job_types_job_type_id",
                table: "job_recommendation_job_types",
                column: "job_type_id",
                principalTable: "job_types",
                principalColumn: "id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
