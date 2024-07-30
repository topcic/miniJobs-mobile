using Application.Applicants.Queries;
using Application.Common.Extensions;
using Domain.Dtos;
using Domain.Interfaces;
using MediatR;

namespace Application.Applicants.Handlers;

internal class ApplicantTryFindQueryHandler : IRequestHandler<ApplicantTryFindQuery, ApplicantDTO>
{
    private readonly IApplicantRepository applicantRepository;

    public ApplicantTryFindQueryHandler(IApplicantRepository applicantRepository)
    {
        this.applicantRepository = applicantRepository;
    }

    public async Task<ApplicantDTO> Handle(ApplicantTryFindQuery request, CancellationToken cancellationToken)
    {

        var applicant = await applicantRepository.GetWithDetailsAsync(request.Id);
        ExceptionExtension.Validate("APPLICANT_NOT_EXISTS", () => applicant == null);
        return applicant;
    }
}