using Domain.Common;
using Domain.Interfaces;

namespace Domain.Entities;
[Table("job_recommendations")]
public class JobRecommendation : BaseAuditableEntity, IEntity<int>
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    [NotMapped]
    public List<int> Cities { get; set; }

    [NotMapped]
    public List<int> JobTypes { get; set; }
}