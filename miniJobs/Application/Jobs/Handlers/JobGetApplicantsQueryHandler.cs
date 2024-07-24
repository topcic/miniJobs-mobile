using Application.Common.Extensions;
using Application.Jobs.Queries;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Jobs.Handlers;

public class JobGetApplicantsQueryHandler : IRequestHandler<JobGetApplicantsQuery, IEnumerable<Applicant>>
{
    private readonly IJobRepository jobRepository;


    public JobGetApplicantsQueryHandler(IJobRepository jobRepository)
    {
        this.jobRepository = jobRepository;
    }


    public async Task<IEnumerable<Applicant>> Handle(JobGetApplicantsQuery request, CancellationToken cancellationToken)
    {
        var job = await jobRepository.TryFindAsync(request.JobId);
        ExceptionExtension.Validate("JOB_NOT_EXISTS", () => job == null);

        return await jobRepository.GetApplicants(request.JobId);
    }
}
