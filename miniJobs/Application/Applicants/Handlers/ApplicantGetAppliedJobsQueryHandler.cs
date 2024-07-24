using Application.Applicants.Queries;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Applicants.Handlers;

public class ApplicantGetAppliedJobsQueryHandler : IRequestHandler<ApplicantGetAppliedJobsQuery, IEnumerable<Job>>
{
    private readonly IJobRepository jobRepository;

    public ApplicantGetAppliedJobsQueryHandler(IJobRepository jobRepository)
    {
        this.jobRepository = jobRepository;
    }


    public async Task<IEnumerable<Job>> Handle(ApplicantGetAppliedJobsQuery request, CancellationToken cancellationToken)
    {
        return await jobRepository.GetApplicantAppliedJobsAsync(request.UserId.Value);
    }
}