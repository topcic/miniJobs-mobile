using Application.Jobs.Commands;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;
using System.Transactions;

namespace Application.Jobs.Handlers;

sealed class JobStep1UpdateCommandHandler(IJobRepository jobRepository) : IRequestHandler<JobStep1UpdateCommand, Job>
{
    public async Task<Job> Handle(JobStep1UpdateCommand command, CancellationToken cancellationToken)

    {
        using var ts = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);
        Job job = await jobRepository.TryFindAsync(command.Request.Id);

        job.Name = command.Request.Name;
        job.Description = command.Request.Description;
        job.StreetAddressAndNumber = command.Request.StreetAddressAndNumber;
        job.CityId = command.Request.CityId;

        job.LastModified = DateTime.UtcNow;
        job.LastModifiedBy = command.UserId;

        await jobRepository.UpdateAsync(job);

        job = await jobRepository.GetWithDetailsAsync(job.Id, false, command.UserId.Value);

        ts.Complete();

        return job;
    }
}