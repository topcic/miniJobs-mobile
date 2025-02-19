using Application.Applicants.Queries;
using Domain.Dtos;
using Domain.Interfaces;
using MediatR;

namespace Application.Applicants.Handlers;

public class ApplicantGetSavedJobsQueryHandler(IJobRepository jobRepository) : IRequestHandler<ApplicantGetSavedJobsQuery, IEnumerable<JobCardDTO>>
{
    public async Task<IEnumerable<JobCardDTO>> Handle(ApplicantGetSavedJobsQuery request, CancellationToken cancellationToken)
    {
        return await jobRepository.GetApplicantSavedJobsAsync(request.UserId.Value);
    }
}