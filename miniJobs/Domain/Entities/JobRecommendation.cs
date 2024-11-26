using Domain.Common;
using Domain.Interfaces;

namespace Domain.Entities;
[Table("job_recommendations")]
public class JobRecommendation : BaseAuditableEntity, IEntity<int>
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    private JobRecommendation() { }

    public static JobRecommendation Create(int userId)
    {
        return new JobRecommendation
        {
            Created = DateTime.UtcNow,
            CreatedBy = userId
        };
    }
}