namespace Domain.Entities;
[Table("job_recommendation_job_types")]

public class JobRecommendationJobType
{
    [Column("job_recommendation_id")]
    public int JobRecommendationId { get; set; }
    [Column("job_type_id")]
    public int JobTypeId { get; set; }
}
