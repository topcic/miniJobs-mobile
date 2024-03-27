using Application.Jobs.Commands;
using Application.Jobs.Models;
using Infrastructure.Persistence;
using MediatR;

namespace Infrastructure.JobStateMachine;

public class PaymentState(IServiceProvider serviceProvider, IMediator mediator, ApplicationDbContext context) : BaseState(serviceProvider, context)
{
    private readonly IMediator mediator = mediator;
    public override async Task<Job> SavePaymentDetails(JobSaveRequest request)
    {
        var job = await mediator.Send(new JobPaymentDetailsSaveCommand(request));
        job.State = Domain.Enums.JobState.Active;
        return job;
    }
}