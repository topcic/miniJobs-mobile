using Application.Common.Commands;
using Application.JobRecommendations.Models;
using Domain.Entities;

namespace Application.JobRecommendations.Commands;

public class JobRecommendationUpdateCommand(int id, JobRecommendationRequest request) : CommandBase<JobRecommendation>
{
    public int Id { get; set; } = id;
    public JobRecommendationRequest Request { get; set; } = request;
}