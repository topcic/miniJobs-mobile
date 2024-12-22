using Application.JobRecommendations.Commands;
using Application.Jobs.Commands;
using Domain.Entities;
using Domain.Enums;
using Domain.Interfaces;
using MediatR;

namespace Application.Jobs.Handlers;

sealed class JobActivateCommandHandler(IJobRepository jobRepository, IMediator mediator) : IRequestHandler<JobActivateCommand, Job>
{
    public async Task<Job> Handle(JobActivateCommand command, CancellationToken cancellationToken)
    {
        Job job = await jobRepository.TryFindAsync(command.Id);

        job.MoveNext(JobCommand.Activate);

        job.ApplicationsStart = DateTime.UtcNow;
        job.LastModified = DateTime.UtcNow;
        job.LastModifiedBy = command.UserId.Value;

        await jobRepository.UpdateAsync(job);

        job = await jobRepository.GetWithDetailsAsync(job.Id, false, command.UserId.Value);
        await mediator.Send(new JobRecommendationNotifyUsersAboutMatchingJobCommand(job.Id, job.Name), cancellationToken);

        return job;
    }
}