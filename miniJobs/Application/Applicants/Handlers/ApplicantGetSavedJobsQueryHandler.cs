using Application.Applicants.Queries;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Applicants.Handlers;

public class ApplicantGetSavedJobsQueryHandler : IRequestHandler<ApplicantGetSavedJobsQuery, IEnumerable<Job>>
{
    private readonly IJobRepository jobRepository;

    public ApplicantGetSavedJobsQueryHandler(IJobRepository jobRepository)
    {
        this.jobRepository = jobRepository;
    }


    public async Task<IEnumerable<Job>> Handle(ApplicantGetSavedJobsQuery request, CancellationToken cancellationToken)
    {
        return await jobRepository.GetApplicantSavedJobsAsync(request.UserId.Value);
    }
}