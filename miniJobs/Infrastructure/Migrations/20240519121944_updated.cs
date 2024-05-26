using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class updated : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {

            migrationBuilder.CreateTable(
                name: "job_question_answers",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    job_question_id = table.Column<int>(type: "int", nullable: false),
                    proposed_answer_id = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_job_question_answers", x => x.id);
                    table.ForeignKey(
                        name: "FK_job_question_answers_job_questions_job_question_id",
                        column: x => x.job_question_id,
                        principalTable: "job_questions",
                        principalColumn: "id");
                    table.ForeignKey(
                        name: "FK_job_question_answers_proposed_answers_proposed_answer_id",
                        column: x => x.proposed_answer_id,
                        principalTable: "proposed_answers",
                        principalColumn: "id");
                });

       
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "job_question_answers");

            migrationBuilder.AddColumn<int>(
                name: "employer_id",
                table: "jobs",
                type: "int",
                nullable: false,
                defaultValue: 0);

          
        }
    }
}
