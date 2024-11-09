using Application.Jobs.Commands;
using AutoMapper;
using Domain.Entities;
using Domain.Enums;
using Domain.Interfaces;
using MediatR;
using System.Transactions;

namespace Application.Jobs.Handlers
{
    public class JobInsertCommandHandler : IRequestHandler<JobInsertCommand, Job>
    {
        private readonly IJobRepository _jobRepository;
        private readonly IMapper _mapper;

        public JobInsertCommandHandler(IJobRepository jobRepository, IMapper mapper)
        {
            _jobRepository = jobRepository;
            _mapper = mapper;
        }

        public async Task<Job> Handle(JobInsertCommand command, CancellationToken cancellationToken)
        {
            using var ts = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);

            var job = _mapper.Map<Job>(command.Request);
            job.Created = DateTime.UtcNow;
            job.CreatedBy = command.UserId;
            job.Status = (int)JobStatus.Draft;

            await _jobRepository.InsertAsync(job);
            ts.Complete();

            return job;
        }
    }
}
