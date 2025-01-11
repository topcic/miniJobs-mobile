using Application.JobApplicationa.Commands;
using Domain.Entities;
using Domain.Enums;
using Domain.Interfaces;
using MediatR;

namespace Application.JobApplications.Handlers;

sealed class JobApplicationApplyCommandHandler(IJobApplicationRepository jobApplicationRepository) : IRequestHandler<JobApplicationApplyCommand, JobApplication>
{
    public async Task<JobApplication> Handle(JobApplicationApplyCommand command, CancellationToken cancellationToken)
    {
        var jobApplication = new JobApplication
        {
            JobId = command.JobId,
            Created = DateTime.UtcNow,
            CreatedBy = command.UserId.Value,
            Status = JobApplicationStatus.Sent
        };

        await jobApplicationRepository.InsertAsync(jobApplication);

        return jobApplication;
    }
}