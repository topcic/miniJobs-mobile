using Application.Common.Models;
using Application.Jobs.Queries;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Jobs.Handlers;

public class JobSearchQueryHandler : IRequestHandler<JobSearchQuery, SearchResponseBase<Job>>
{
    private readonly IJobRepository jobRepository;

    public JobSearchQueryHandler(IJobRepository jobRepository)
    {
        this.jobRepository = jobRepository;
    }


    public async Task<SearchResponseBase<Job>> Handle(JobSearchQuery request, CancellationToken cancellationToken)
    {

        SearchResponseBase<Job> result = new SearchResponseBase<Job>();
        result.Count = await jobRepository.SearchCountAsync(request.SearchRequest.SearchText, request.SearchRequest.CityId, request.SearchRequest.JobTypeId);
        result.Result = await jobRepository.SearchAsync(request.SearchRequest.SearchText, request.SearchRequest.Limit,
            request.SearchRequest.Offset, request.SearchRequest.CityId, request.SearchRequest.JobTypeId);
        return result;
    }
}