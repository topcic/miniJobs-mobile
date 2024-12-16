using Application.Common.Models;
using Application.Jobs.Queries;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Jobs.Handlers;

sealed class JobSearchQueryHandler(IJobRepository jobRepository) : IRequestHandler<JobSearchQuery, SearchResponseBase<Job>>
{
    public async Task<SearchResponseBase<Job>> Handle(JobSearchQuery request, CancellationToken cancellationToken)
    {
        SearchResponseBase<Job> result = new SearchResponseBase<Job>();
        result.Count = await jobRepository.SearchCountAsync(request.SearchRequest.SearchText, request.SearchRequest.CityId);
        result.Result = await jobRepository.SearchAsync(request.SearchRequest.SearchText, request.SearchRequest.Limit,
            request.SearchRequest.Offset, request.SearchRequest.CityId, request.SearchRequest.SortOrder);
        return result;
    }
}