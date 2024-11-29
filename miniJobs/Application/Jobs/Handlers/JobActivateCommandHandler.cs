using Application.Common.Extensions;
using Application.JobRecommendations.Commands;
using Application.Jobs.Commands;
using Domain.Entities;
using Domain.Enums;
using Domain.Interfaces;
using MediatR;

namespace Application.Jobs.Handlers;

public class JobActivateCommandHandler(IJobRepository jobRepository, IMediator mediator) : IRequestHandler<JobActivateCommand, Job>
{
    public async Task<Job> Handle(JobActivateCommand command, CancellationToken cancellationToken)
    {
        Job job = await jobRepository.TryFindAsync(command.Id);

        ExceptionExtension.Validate("JOB_NOT_EXISTS", () => job == null);

        job.MoveNext(JobCommand.Activate);

        await jobRepository.UpdateAsync(job);

        var isApplicant = command.RoleId == Roles.Applicant.ToString();
        job = await jobRepository.GetWithDetailsAsync(job.Id, isApplicant, command.UserId.Value);
        await mediator.Send(new JobRecommendationNotifyUsersAboutMatchingJobCommand(job.Id, job.Name), cancellationToken);

        return job;
    }
}