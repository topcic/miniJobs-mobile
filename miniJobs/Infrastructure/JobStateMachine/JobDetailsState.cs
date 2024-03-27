using Application.Jobs.Commands;
using Application.Jobs.Models;
using Infrastructure.Persistence;
using MediatR;

namespace Infrastructure.JobStateMachine;

public class JobDetailsState(IServiceProvider serviceProvider, ApplicationDbContext context, IMediator mediator) : BaseState(serviceProvider, context)
{
    private readonly IMediator mediator = mediator;
    public override async Task<Job> SaveDetails(JobSaveRequest request)
    {
        return await mediator.Send(new JobDetailsSaveCommand(request));
    }
}
