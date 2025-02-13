using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Infrastructure.Persistence.Migrations
{
    /// <inheritdoc />
    public partial class add_hangfie_db : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            string basePath = "/app/Infrastructure/Persistence/Migrations/InitialDataScripts";

            var sqlFile = Path.Combine(basePath, "init.sql");
            migrationBuilder.Sql(File.ReadAllText(sqlFile), suppressTransaction: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {

        }
    }
}
