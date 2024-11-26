namespace Application.JobRecommendations.Models;

public class JobRecommendationRequest
{
    public List<int> Cities { get; set; } = [];
    public List<int> JobTypes { get; set; } = [];
}
