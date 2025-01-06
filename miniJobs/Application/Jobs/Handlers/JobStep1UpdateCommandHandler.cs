using Application.Jobs.Commands;
using AutoMapper;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;
using System.Transactions;

namespace Application.Jobs.Handlers;

sealed class JobStep1UpdateCommandHandler(IJobRepository jobRepository, IMapper mapper) : IRequestHandler<JobStep1UpdateCommand, Job>
{
    public async Task<Job> Handle(JobStep1UpdateCommand command, CancellationToken cancellationToken)

    {
        using var ts = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);
        Job job = await jobRepository.TryFindAsync(command.Request.Id.Value);

        mapper.Map(command.Request, job);

        job.LastModified = DateTime.UtcNow;
        job.LastModifiedBy = command.UserId;

        await jobRepository.UpdateAsync(job);

        job = await jobRepository.GetWithDetailsAsync(job.Id, false, command.UserId.Value);

        ts.Complete();

        return job;
    }
}