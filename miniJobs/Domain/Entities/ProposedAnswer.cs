using Domain.Interfaces;

namespace Domain.Entities;
[Table("proposed_answers")]
public class ProposedAnswer : IEntity<int>
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    [Column("answer")]
    public string Answer { get; set; }

    [Column("question_id")]
    public int QuestionId { get; set; }

}
