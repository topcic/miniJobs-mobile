using Application.Applicants.Models;
using Application.Applicants.Queries;
using Application.Common.Models;
using AutoMapper;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Applicants.Handlers;

public class ApplicantSearchAsyncQueryHandlers : IRequestHandler<ApplicantSearchAsyncQuery, SearchResponseBase<ApplicantResponse>>
{
    private readonly IApplicantRepository applicantRepository;
    private readonly IMapper mapper;

    public ApplicantSearchAsyncQueryHandlers(IApplicantRepository applicantRepository, IMapper mapper)
    {
        this.applicantRepository = applicantRepository;
        this.mapper = mapper;
    }


    public async Task<SearchResponseBase<ApplicantResponse>> Handle(ApplicantSearchAsyncQuery request, CancellationToken cancellationToken)
    {

        SearchResponseBase<ApplicantResponse> result = new SearchResponseBase<ApplicantResponse>();
        var results= await applicantRepository.SearchAsync(request.SearchRequest.SearchText, request.SearchRequest.Limit,
            request.SearchRequest.Offset, request.SearchRequest.CityId, request.SearchRequest.JobTypeId);

        IEnumerable<ApplicantResponse> applicantResponses = mapper.Map<IEnumerable<ApplicantResponse>>(results);
        result.Result =mapper.Map<IEnumerable<ApplicantResponse>>(results);
        result.Count = await applicantRepository.SearchCountAsync(request.SearchRequest.SearchText, request.SearchRequest.CityId, request.SearchRequest.JobTypeId);
        return result;
    }
}
