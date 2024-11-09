using Application.JobApplications.Commands;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.JobApplications.Handlers;
sealed class JobApplicationDeleteCommandHandler : IRequestHandler<JobApplicationDeleteCommand, JobApplication>
{
    private readonly IJobApplicationRepository jobApplicationRepository;

    public JobApplicationDeleteCommandHandler(IJobApplicationRepository jobApplicationRepository)
    {
        this.jobApplicationRepository = jobApplicationRepository;
    }

    public async Task<JobApplication> Handle(JobApplicationDeleteCommand command, CancellationToken cancellationToken)
    {
        var jobApplication = await jobApplicationRepository.FindOneAsync(x => x.CreatedBy == command.UserId.Value && x.JobId == command.JobId && x.IsDeleted == false);

        jobApplication.IsDeleted = true;
        jobApplication.LastModified = DateTime.UtcNow;
        jobApplication.LastModifiedBy = command.UserId.Value;
        await jobApplicationRepository.UpdateAsync(jobApplication);

        return jobApplication;
    }
}