using Domain.Interfaces;

namespace Domain.Entities;

[Table("job_questions")]
public class JobQuestion : IEntity<int>
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    [Column("question_id")]
    public int QuestionId { get; set; }

    [Column("job_id")]
    public int JobId { get; set; }
}