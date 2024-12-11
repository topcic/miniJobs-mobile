using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class added_job_recommendations : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "job_recommendations",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    created = table.Column<DateTime>(type: "datetime2", nullable: false),
                    created_by = table.Column<int>(type: "int", nullable: true),
                    last_modified = table.Column<DateTime>(type: "datetime2", nullable: true),
                    last_modified_by = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_job_recommendations", x => x.id);
                    table.ForeignKey(
                        name: "FK_job_recommendations_users_created_by",
                        column: x => x.created_by,
                        principalTable: "users",
                        principalColumn: "id");
                    table.ForeignKey(
                        name: "FK_job_recommendations_users_last_modified_by",
                        column: x => x.last_modified_by,
                        principalTable: "users",
                        principalColumn: "id");
                });

            migrationBuilder.CreateTable(
                name: "job_recommendation_cites",
                columns: table => new
                {
                    job_recommendation_id = table.Column<int>(type: "int", nullable: false),
                    city_id = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_job_recommendation_cites", x => new { x.job_recommendation_id, x.city_id });
                    table.ForeignKey(
                        name: "FK_job_recommendation_cites_cities_city_id",
                        column: x => x.city_id,
                        principalTable: "cities",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_job_recommendation_cites_job_recommendations_job_recommendation_id",
                        column: x => x.job_recommendation_id,
                        principalTable: "job_recommendations",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "job_recommendation_job_types",
                columns: table => new
                {
                    job_recommendation_id = table.Column<int>(type: "int", nullable: false),
                    job_type_id = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_job_recommendation_job_types", x => new { x.job_recommendation_id, x.job_type_id });
                    table.ForeignKey(
                        name: "FK_job_recommendation_job_types_job_recommendations_job_recommendation_id",
                        column: x => x.job_recommendation_id,
                        principalTable: "job_recommendations",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_job_recommendation_job_types_job_types_job_type_id",
                        column: x => x.job_type_id,
                        principalTable: "job_types",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_job_applications_last_modified_by",
                table: "job_applications",
                column: "last_modified_by");

            migrationBuilder.CreateIndex(
                name: "IX_job_recommendation_cites_city_id",
                table: "job_recommendation_cites",
                column: "city_id");

            migrationBuilder.CreateIndex(
                name: "IX_job_recommendation_job_types_job_type_id",
                table: "job_recommendation_job_types",
                column: "job_type_id");

            migrationBuilder.CreateIndex(
                name: "IX_job_recommendations_last_modified_by",
                table: "job_recommendations",
                column: "last_modified_by");

            migrationBuilder.CreateIndex(
                name: "IX_JobRecommendation_Unique_User",
                table: "job_recommendations",
                column: "created_by",
                unique: true,
                filter: "[created_by] IS NOT NULL");

            migrationBuilder.AddForeignKey(
                name: "FK_job_applications_users_last_modified_by",
                table: "job_applications",
                column: "last_modified_by",
                principalTable: "users",
                principalColumn: "id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_job_applications_users_last_modified_by",
                table: "job_applications");

            migrationBuilder.DropTable(
                name: "job_recommendation_cites");

            migrationBuilder.DropTable(
                name: "job_recommendation_job_types");

            migrationBuilder.DropTable(
                name: "job_recommendations");

            migrationBuilder.DropIndex(
                name: "IX_job_applications_last_modified_by",
                table: "job_applications");
        }
    }
}
