using Application.Jobs.Commands;
using Application.Jobs.Models;
using Infrastructure.Persistence;
using MediatR;

namespace Infrastructure.JobStateMachine;

public class InitialJobState(IServiceProvider serviceProvider, ApplicationDbContext context, IMediator mediator) : BaseState(serviceProvider, context)
{
    private readonly IMediator mediator = mediator;
    public override async Task<Job> Insert(JobInsertRequest request)
    {
        var job = await mediator.Send(new JobInsertCommand(request));
        job.State = (int)Domain.Enums.JobState.JobDetails;
        return job;
    }
}