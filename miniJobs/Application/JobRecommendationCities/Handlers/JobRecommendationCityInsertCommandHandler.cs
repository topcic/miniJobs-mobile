using Application.JobRecommendationCities.Commands;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.JobRecommendationCities.Handlers;

sealed class JobRecommendationCityInsertCommandHandler(IJobRecommendationCityRepository jobRecommendationCityRepository) : IRequestHandler<JobRecommendationCityInsertCommand, bool>
{
    public async Task<bool> Handle(JobRecommendationCityInsertCommand command, CancellationToken cancellationToken)
    {
        await jobRecommendationCityRepository.InsertRangeAsync(
             command.Cities.Select(cityId => new JobRecommendationCity
             {
                 CityId = cityId,
                 JobRecommendationId = command.JobRecommendationId
             }).ToList());

        return true;
    }
}