using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class updated_job_applications : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropUniqueConstraint(
                name: "AK_job_applications_job_id_created_by",
                table: "job_applications");

            migrationBuilder.AlterColumn<int>(
                name: "created_by",
                table: "job_applications",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.CreateIndex(
                name: "IX_job_applications_job_id",
                table: "job_applications",
                column: "job_id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_job_applications_job_id",
                table: "job_applications");

            migrationBuilder.AlterColumn<int>(
                name: "created_by",
                table: "job_applications",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.AddUniqueConstraint(
                name: "AK_job_applications_job_id_created_by",
                table: "job_applications",
                columns: new[] { "job_id", "created_by" });
        }
    }
}
