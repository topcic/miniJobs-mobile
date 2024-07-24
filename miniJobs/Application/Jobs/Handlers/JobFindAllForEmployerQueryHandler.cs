using Application.Jobs.Queries;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Jobs.Handlers;

sealed class JobFindAllForEmployerQueryHandler : IRequestHandler<JobFindAllForEmployerQuery, IEnumerable<Job>>
{
    private readonly IJobRepository jobRepository;


    public JobFindAllForEmployerQueryHandler(IJobRepository jobRepository)
    {
        this.jobRepository = jobRepository;
    }


    public async Task<IEnumerable<Job>> Handle(JobFindAllForEmployerQuery request, CancellationToken cancellationToken)
    {

        return await  jobRepository.GetEmployerJobsAsync(request.UserId.Value);
    }
}
