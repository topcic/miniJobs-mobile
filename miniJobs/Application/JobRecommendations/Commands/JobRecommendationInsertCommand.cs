using Application.Common.Commands;
using Application.JobRecommendations.Models;
using Domain.Entities;

namespace Application.JobRecommendations.Commands;

public class JobRecommendationInsertCommand(JobRecommendationRequest request) : CommandBase<JobRecommendation>
{
    public JobRecommendationRequest Request { get; set; } = request;
}
