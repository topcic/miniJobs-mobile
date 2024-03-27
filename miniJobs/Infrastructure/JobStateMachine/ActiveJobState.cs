using Application.Jobs.Commands;
using Azure.Core;
using Infrastructure.Persistence;
using MediatR;
namespace Infrastructure.JobStateMachine;

public class ActiveJobState(IServiceProvider serviceProvider, IMediator mediator, ApplicationDbContext context) : BaseState(serviceProvider,context)
{
    private readonly IMediator mediator = mediator;
    public override async Task<Job> Activate(int id, int status)
    {
        var job = await mediator.Send(new JobActivateCommand(id, status));
        job.State = Domain.Enums.JobState.Active;
        return job;
    }
}