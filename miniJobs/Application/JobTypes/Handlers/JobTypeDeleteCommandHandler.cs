using Application.JobTypes.Commands;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.JobTypes.Handlers;

public class JobTypeDeleteCommandHandler(IJobTypeRepository repository) : IRequestHandler<JobTypeActivateCommand, JobType>
{
    public async Task<JobType> Handle(JobTypeActivateCommand command, CancellationToken cancellationToken)
    {
        var model = await repository.TryFindAsync(command.Id);

        model.IsDeleted = true;

        await repository.UpdateAsync(model);
        return model;
    }
}