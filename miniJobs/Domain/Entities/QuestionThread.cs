using Domain.Common;
using Domain.Interfaces;

namespace Domain.Entities;

[Table("question_threads")]
public class QuestionThread :BaseAuditableEntity, IEntity<int>
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    [Column("name")]
    public string Name { get; set; }

    [Column("job_id")]
    public int JobId { get; set; }
}