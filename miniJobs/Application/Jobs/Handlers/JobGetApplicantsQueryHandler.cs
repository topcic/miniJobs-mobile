using Application.Jobs.Queries;
using AutoMapper;
using Domain.Dtos;
using Domain.Interfaces;
using MediatR;

namespace Application.Jobs.Handlers;

sealed class JobGetApplicantsQueryHandler(IJobRepository jobRepository, IMapper mapper) : IRequestHandler<JobGetApplicantsQuery, IEnumerable<ApplicantDTO>>
{
    public async Task<IEnumerable<ApplicantDTO>> Handle(JobGetApplicantsQuery request, CancellationToken cancellationToken)
    {
        var job = await jobRepository.TryFindAsync(request.JobId);
        return await jobRepository.GetApplicants(request.JobId);
    }
}
