using Application.Common.Commands;

namespace Application.JobRecommendationCities.Commands;

public class JobRecommendationCityDeleteCommand(int jobRecommendationId) : CommandBase<bool>
{
    public int JobRecommendationId { get; set; } = jobRecommendationId;
}
