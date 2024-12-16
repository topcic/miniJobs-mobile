using Application.Jobs.Commands;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Jobs.Handlers;

sealed class JobSaveCommandHandler(IJobRepository jobRepository, ISavedJobRepository savedJobRepository) : IRequestHandler<JobSaveCommand, Job>
{
    public async Task<Job> Handle(JobSaveCommand command, CancellationToken cancellationToken)
    {
        Job job = await jobRepository.GetWithDetailsAsync(command.Id, true, command.UserId.Value);

        var savedJob = new SavedJob
        {
            JobId = job.Id,
            Created = DateTime.UtcNow,
            CreatedBy = command.UserId.Value
        };

        await savedJobRepository.InsertAsync(savedJob);
        job.IsSaved = true;

        return job;
    }
}