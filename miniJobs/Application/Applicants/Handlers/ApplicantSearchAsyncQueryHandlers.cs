using Application.Applicants.Models;
using Application.Applicants.Queries;
using Application.Common.Models;
using AutoMapper;
using Domain.Dtos;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Applicants.Handlers;

public class ApplicantSearchAsyncQueryHandlers : IRequestHandler<ApplicantSearchAsyncQuery, SearchResponseBase<ApplicantDTO>>
{
    private readonly IApplicantRepository applicantRepository;

    public ApplicantSearchAsyncQueryHandlers(IApplicantRepository applicantRepository)
    {
        this.applicantRepository = applicantRepository;
    }


    public async Task<SearchResponseBase<ApplicantDTO>> Handle(ApplicantSearchAsyncQuery request, CancellationToken cancellationToken)
    {

        SearchResponseBase<ApplicantDTO> result = new SearchResponseBase<ApplicantDTO>
        {
            Result = await applicantRepository.SearchAsync(request.SearchRequest.SearchText, request.SearchRequest.Limit,
            request.SearchRequest.Offset, request.SearchRequest.CityId, request.SearchRequest.JobTypeId),
            Count = await applicantRepository.SearchCountAsync(request.SearchRequest.SearchText, request.SearchRequest.CityId, request.SearchRequest.JobTypeId)
        };
        return result;
    }
}
