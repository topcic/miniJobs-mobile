using Application.Common.Models;
using Application.Jobs.Queries;
using Domain.Dtos;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Jobs.Handlers;

sealed class JobSearchQueryHandler(IJobRepository jobRepository) : IRequestHandler<JobSearchQuery, SearchResponseBase<JobCardDTO>>
{
    public async Task<SearchResponseBase<JobCardDTO>> Handle(JobSearchQuery request, CancellationToken cancellationToken)
    {
        SearchResponseBase<JobCardDTO> result = new SearchResponseBase<JobCardDTO>();
        result.Count = await jobRepository.SearchCountAsync(request.SearchRequest.SearchText, request.SearchRequest.CityId);
        result.Result = await jobRepository.SearchAsync(request.SearchRequest.SearchText, request.SearchRequest.Limit,
            request.SearchRequest.Offset, request.SearchRequest.CityId, request.SearchRequest.SortOrder);
        return result;
    }
}