using Application.JobTypes.Queries;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.JobTypes.Handlers;

public class JobTypeFindAllQueryHandler(IJobTypeRepository jobTypeRepository) : IRequestHandler<JobTypeFindAllQuery, IEnumerable<JobType>>
{
    private readonly IJobTypeRepository jobTypeRepository = jobTypeRepository;


    public async Task<IEnumerable<JobType>> Handle(JobTypeFindAllQuery request, CancellationToken cancellationToken)
    {
        return await jobTypeRepository.FindAllAsync();
    }
}