using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class added_scripts_for_questions : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_proposed_answers_question_id",
                table: "proposed_answers");

            migrationBuilder.CreateIndex(
                name: "IX_proposed_answers_question_id",
                table: "proposed_answers",
                column: "question_id");

            var sqlFile = Path.Combine(Directory.GetParent(Directory.GetCurrentDirectory()).FullName, "Infrastructure/Persistence/Migrations/InitialDataScripts/add_questions.sql");
            migrationBuilder.Sql(File.ReadAllText(sqlFile));

            sqlFile = Path.Combine(Directory.GetParent(Directory.GetCurrentDirectory()).FullName, "Infrastructure/Persistence/Migrations/InitialDataScripts/add_proposed_answers.sql");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_proposed_answers_question_id",
                table: "proposed_answers");

            migrationBuilder.CreateIndex(
                name: "IX_proposed_answers_question_id",
                table: "proposed_answers",
                column: "question_id",
                unique: true);
        }
    }
}
