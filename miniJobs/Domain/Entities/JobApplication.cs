using Domain.Common;
using Domain.Enums;
using Domain.Interfaces;

namespace Domain.Entities;

[Table("job_applications")]
public class JobApplication : BaseAuditableEntity, IEntity<int>
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    [Column("job_id")]
    public int JobId { get; set; }

    [Column("status")]
    public JobApplicationStatus Status { get; set; }

    [Column("is_deleted")]
    public bool IsDeleted { get; set; }

    [NotMapped]
    public Job Job { get; set; }

    [NotMapped]
    public bool HasRated { get; set; }

    [NotMapped]
    public string CreatedByName { get; set; }

    [NotMapped]
    public Rating Rating { get; set; }
}