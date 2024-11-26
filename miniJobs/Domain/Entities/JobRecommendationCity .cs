namespace Domain.Entities;
[Table("job_recommendation_cites")]

public class JobRecommendationCity
{
    [Column("job_recommendation_id")]
    public int JobRecommendationId { get; set; }
    [Column("city_id")]
    public int CityId { get; set; }
}
