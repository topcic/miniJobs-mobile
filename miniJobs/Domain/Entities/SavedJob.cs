using Domain.Common;

namespace Domain.Entities;
[Table("saved_jobs")]

public class SavedJob : BaseAuditableEntity
{
    [Key]
    public int Id { get; set; }

    [Column("job_id")]
    public int JobId { get; set; }

    [Column("is_deleted")]
    public bool IsDeleted { get; set; }
}