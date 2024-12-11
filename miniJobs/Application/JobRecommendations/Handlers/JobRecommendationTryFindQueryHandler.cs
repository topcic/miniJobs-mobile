using Application.JobRecommendations.Queries;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.JobRecommendations.Handlers;

sealed class JobRecommendationTryFindQueryHandler(IJobRecommendationRepository jobRecommendationRepository, IJobRecommendationCityRepository jobRecommendationCityRepository, IJobRecommendationJobTypeRepository jobRecommendationJobTypeRepository) : IRequestHandler<JobRecommendationTryFindQuery, JobRecommendation>
{
    public async Task<JobRecommendation> Handle(JobRecommendationTryFindQuery query, CancellationToken cancellationToken)
    {
        var jobRecommendation = await jobRecommendationRepository.FindOneAsync(x => x.CreatedBy == query.UserId);
        if (jobRecommendation != null)
        {
            jobRecommendation.Cities = (await jobRecommendationCityRepository.FindAllAsync(jobRecommendation.Id)).Select(x => x.CityId).ToList();
            jobRecommendation.JobTypes = (await jobRecommendationJobTypeRepository.FindAllAsync(jobRecommendation.Id)).Select(x => x.JobTypeId).ToList();
        }

        return jobRecommendation;
    }
}