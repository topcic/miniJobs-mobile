using Application.Common.Extensions;
using Application.Jobs.Queries;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Jobs.Handlers;

sealed class JobFindAllForEmployeerQueryHandler : IRequestHandler<JobFindAllForEmployeerQuery, IEnumerable<Job>>
{
    private readonly IJobRepository jobRepository;


    public JobFindAllForEmployeerQueryHandler(IJobRepository jobRepository)
    {
        this.jobRepository = jobRepository;
    }


    public async Task<IEnumerable<Job>> Handle(JobFindAllForEmployeerQuery request, CancellationToken cancellationToken)
    {

        return await  jobRepository.GetEmployeerJobsAsync(request.UserId.Value);
    }
}
