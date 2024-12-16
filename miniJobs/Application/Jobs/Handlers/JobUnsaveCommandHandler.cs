using Application.Jobs.Commands;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Jobs.Handlers;

sealed class JobUnsaveCommandHandler(IJobRepository jobRepository, ISavedJobRepository savedJobRepository) : IRequestHandler<JobUnsaveCommand, Job>
{
    public async Task<Job> Handle(JobUnsaveCommand command, CancellationToken cancellationToken)
    {
        Job job = await jobRepository.GetWithDetailsAsync(command.JobId, true, command.UserId.Value);

        var savedJob = await savedJobRepository.FindOneAsync(x => x.CreatedBy == command.UserId.Value && x.JobId == job.Id && x.IsDeleted == false);
        savedJob.IsDeleted = true;
        savedJob.LastModified = DateTime.UtcNow;
        savedJob.LastModifiedBy = command.UserId.Value;
        await savedJobRepository.UpdateAsync(savedJob);
        job.IsSaved = false;

        return job;
    }
}