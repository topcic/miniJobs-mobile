using Application.Common.Commands;
using Domain.Entities;

namespace Application.JobApplications.Commands;

public class JobApplicationAcceptCommand(int jobId,int jobApplicationId, bool accept) : CommandBase<JobApplication>
{
    public int JobId { get; set; } = jobId;
    public int JobApplicationId { get; set; } = jobApplicationId;
    public bool Accept { get; set; } = accept;
}
