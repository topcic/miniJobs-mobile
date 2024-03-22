using Domain.Common;
using Domain.Interfaces;

namespace Domain.Entities;

[Table("messages")]
public class Message : BaseAuditableEntity, IEntity<int>
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    [Column("content")]
    public string Content { get; set; }

    [Column("question_thread_id")]
    public int QuestionThreadId { get; set; }
}