using Application.Common.Commands;

namespace Application.JobRecommendationCities.Commands;

public class JobRecommendationCityUpdateCommand(List<int> cities, int jobRecommendationId) : CommandBase<bool>
{
    public int JobRecommendationId { get; set; } = jobRecommendationId;
    public List<int> Cities { get; set; } = cities;
}
