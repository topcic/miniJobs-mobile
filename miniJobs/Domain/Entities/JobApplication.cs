using Domain.Common;
using Domain.Enums;

namespace Domain.Entities;

[Table("job_applications")]
public class PublicCallApplication : BaseAuditableEntity
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    [Column("job_id")]
    public int JobId { get; set; }

    [Column("status")]
    public JobApplicationStatus Status { get; set; }
}