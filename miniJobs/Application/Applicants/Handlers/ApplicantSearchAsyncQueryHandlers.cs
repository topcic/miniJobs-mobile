using Application.Applicants.Queries;
using Application.Common.Models;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Applicants.Handlers;

public class ApplicantSearchAsyncQueryHandlers : IRequestHandler<ApplicantSearchAsyncQuery, SearchResponseBase<Applicant>>
{
    private readonly IApplicantRepository applicantRepository;

    public ApplicantSearchAsyncQueryHandlers(IApplicantRepository applicantRepository)
    {
        this.applicantRepository = applicantRepository;
    }


    public async Task<SearchResponseBase<Applicant>> Handle(ApplicantSearchAsyncQuery request, CancellationToken cancellationToken)
    {
        
        SearchResponseBase<Applicant> result = new SearchResponseBase<Applicant>();
        result.Result = await applicantRepository.SearchAsync(request.SearchRequest.SearchText, request.SearchRequest.Limit,
            request.SearchRequest.Offset, request.SearchRequest.CityId, request.SearchRequest.JobTypeId);
        result.Count = await applicantRepository.SearchCountAsync(request.SearchRequest.SearchText, request.SearchRequest.CityId, request.SearchRequest.JobTypeId);
        return result;
    }
}
