using Domain.Common;
using Domain.Interfaces;

namespace Domain.Entities;
[Table("saved_jobs")]

public class SavedJob : BaseAuditableEntity, IEntity<int>
{
    [Key]
    public int Id { get; set; }

    [Column("job_id")]
    public int JobId { get; set; }

    [Column("is_deleted")]
    public bool IsDeleted { get; set; }
}