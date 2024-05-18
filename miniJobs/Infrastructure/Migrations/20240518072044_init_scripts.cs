using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class init_scripts : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            var sqlFile = Path.Combine(Directory.GetParent(Directory.GetCurrentDirectory()).FullName, "Infrastructure/Persistence/Migrations/InitialDataScripts/add_roles.sql");
            migrationBuilder.Sql(File.ReadAllText(sqlFile));

            sqlFile = Path.Combine(Directory.GetParent(Directory.GetCurrentDirectory()).FullName, "Infrastructure/Persistence/Migrations/InitialDataScripts/add_default_user.sql");
            migrationBuilder.Sql(File.ReadAllText(sqlFile));

            sqlFile = Path.Combine(Directory.GetParent(Directory.GetCurrentDirectory()).FullName, "Infrastructure/Persistence/Migrations/InitialDataScripts/add_cantons.sql");
            migrationBuilder.Sql(File.ReadAllText(sqlFile));

            sqlFile = Path.Combine(Directory.GetParent(Directory.GetCurrentDirectory()).FullName, "Infrastructure/Persistence/Migrations/InitialDataScripts/add_default_country.sql");
            migrationBuilder.Sql(File.ReadAllText(sqlFile));

            sqlFile = Path.Combine(Directory.GetParent(Directory.GetCurrentDirectory()).FullName, "Infrastructure/Persistence/Migrations/InitialDataScripts/add_cities.sql");
            migrationBuilder.Sql(File.ReadAllText(sqlFile));

            sqlFile = Path.Combine(Directory.GetParent(Directory.GetCurrentDirectory()).FullName, "Infrastructure/Persistence/Migrations/InitialDataScripts/add_job_types.sql");
            migrationBuilder.Sql(File.ReadAllText(sqlFile));

            sqlFile = Path.Combine(Directory.GetParent(Directory.GetCurrentDirectory()).FullName, "Infrastructure/Persistence/Migrations/InitialDataScripts/add_questions.sql");
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
