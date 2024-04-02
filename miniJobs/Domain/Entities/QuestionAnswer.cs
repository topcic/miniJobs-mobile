using Domain.Interfaces;

namespace Domain.Entities;


[Table("question_answers")]
public class QuestionAnswer : IEntity<int>
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    [Column("question_id")]
    public int QuestionId { get; set; }
    [Column("proposed_answer_id")]
    public int ProposedAnswerId { get; set; }
}