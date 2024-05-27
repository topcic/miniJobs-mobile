using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class updated_jobss : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "job_type_id",
                table: "jobs",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateIndex(
                name: "IX_jobs_job_type_id",
                table: "jobs",
                column: "job_type_id");

            migrationBuilder.AddForeignKey(
                name: "FK_jobs_job_types_job_type_id",
                table: "jobs",
                column: "job_type_id",
                principalTable: "job_types",
                principalColumn: "id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_jobs_job_types_job_type_id",
                table: "jobs");

            migrationBuilder.DropIndex(
                name: "IX_jobs_job_type_id",
                table: "jobs");

            migrationBuilder.DropColumn(
                name: "job_type_id",
                table: "jobs");
        }
    }
}
