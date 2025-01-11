using Application.Applicants.Queries;
using Domain.Dtos;
using Domain.Interfaces;
using MediatR;

namespace Application.Applicants.Handlers;

internal class ApplicantTryFindQueryHandler(IApplicantRepository applicantRepository) : IRequestHandler<ApplicantTryFindQuery, ApplicantDTO>
{
    public async Task<ApplicantDTO> Handle(ApplicantTryFindQuery request, CancellationToken cancellationToken)
    {
        return await applicantRepository.GetWithDetailsAsync(request.Id); ;
    }
}