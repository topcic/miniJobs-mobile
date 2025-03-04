using Application.JobTypes.Queries;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.JobTypes.Handlers;

public class JobTypeFindAllQueryHandler(IJobTypeRepository jobTypeRepository) : IRequestHandler<JobTypeFindAllQuery, IEnumerable<JobType>>
{
    public async Task<IEnumerable<JobType>> Handle(JobTypeFindAllQuery request, CancellationToken cancellationToken)
    {
        return  jobTypeRepository.Find(x=>x.IsDeleted==false);
    }
}