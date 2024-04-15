using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class added_scripts_for_questions_second_time : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            var sqlFile = Path.Combine(Directory.GetParent(Directory.GetCurrentDirectory()).FullName, "Infrastructure/Persistence/Migrations/InitialDataScripts/add_questions.sql");
            migrationBuilder.Sql(File.ReadAllText(sqlFile));

            sqlFile = Path.Combine(Directory.GetParent(Directory.GetCurrentDirectory()).FullName, "Infrastructure/Persistence/Migrations/InitialDataScripts/add_proposed_answers.sql");
            migrationBuilder.Sql(File.ReadAllText(sqlFile));
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {

        }
    }
}
