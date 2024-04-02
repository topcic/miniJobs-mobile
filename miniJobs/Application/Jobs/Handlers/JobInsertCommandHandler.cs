using Application.Jobs.Commands;
using AutoMapper;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Jobs.Handlers;

public class JobInsertCommandHandler(IJobRepository jobRepository, IMapper mapper) : IRequestHandler<JobInsertCommand, Job>
{
    private readonly IJobRepository jobRepository = jobRepository;
    private readonly IMapper mapper = mapper;


    public async Task<Job> Handle(JobInsertCommand command, CancellationToken cancellationToken)
    {
        var job = mapper.Map<Job>(command.Request);
        job.Created = DateTime.UtcNow;
        job.CreatedBy = command.UserId;
        job.LastModified = DateTime.UtcNow;
        job.LastModifiedBy = command.UserId;
        job.Status = Domain.Enums.JobStatus.Draft;

        await jobRepository.InsertAsync(job);

        return job;
    }
}
