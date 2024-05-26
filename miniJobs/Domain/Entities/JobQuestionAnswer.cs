using Domain.Interfaces;

namespace Domain.Entities;


[Table("job_question_answers")]
public class JobQuestionAnswer : IEntity<int>
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    [Column("job_question_id")]
    public int JobQuestionId { get; set; }
    [Column("proposed_answer_id")]
    public int ProposedAnswerId { get; set; }
}