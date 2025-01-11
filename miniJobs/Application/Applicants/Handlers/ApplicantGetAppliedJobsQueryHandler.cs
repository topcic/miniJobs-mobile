using Application.Applicants.Queries;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Applicants.Handlers;

public class ApplicantGetAppliedJobsQueryHandler(IJobRepository jobRepository) : IRequestHandler<ApplicantGetAppliedJobsQuery, IEnumerable<JobApplication>>
{
    public async Task<IEnumerable<JobApplication>> Handle(ApplicantGetAppliedJobsQuery request, CancellationToken cancellationToken)
    {
        return await jobRepository.GetApplicantAppliedJobsAsync(request.UserId.Value);
    }
}