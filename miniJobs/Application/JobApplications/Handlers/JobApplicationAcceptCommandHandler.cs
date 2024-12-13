using Application.JobApplications.Commands;
using Domain.Entities;
using Domain.Enums;
using Domain.Interfaces;
using MediatR;

namespace Application.JobApplications.Handlers;

sealed class JobApplicationAcceptCommandHandler(IJobApplicationRepository jobApplicationRepository) : IRequestHandler<JobApplicationAcceptCommand, JobApplication>
{
    public async Task<JobApplication> Handle(JobApplicationAcceptCommand command, CancellationToken cancellationToken)
    {
        var jobApplication = await jobApplicationRepository.TryFindAsync(command.JobApplicationId);

        jobApplication.LastModified = DateTime.UtcNow;
        jobApplication.LastModifiedBy = command.UserId.Value;
        jobApplication.Status = command.Accept ? JobApplicationStatus.Accepted : JobApplicationStatus.Rejected;
        await jobApplicationRepository.UpdateAsync(jobApplication);

        return jobApplication;
    }
}