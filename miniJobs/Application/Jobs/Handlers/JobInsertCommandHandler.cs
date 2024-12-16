using Application.Jobs.Commands;
using AutoMapper;
using Domain.Entities;
using Domain.Enums;
using Domain.Interfaces;
using MediatR;
using System.Transactions;

namespace Application.Jobs.Handlers;

sealed class JobInsertCommandHandler(IJobRepository jobRepository, IMapper mapper) : IRequestHandler<JobInsertCommand, Job>
{
    public async Task<Job> Handle(JobInsertCommand command, CancellationToken cancellationToken)
    {
        using var ts = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);

        var job = mapper.Map<Job>(command.Request);
        job.Created = DateTime.UtcNow;
        job.CreatedBy = command.UserId;
        job.Status = (int)JobStatus.Draft;

        await jobRepository.InsertAsync(job);
        ts.Complete();

        return job;
    }
}
