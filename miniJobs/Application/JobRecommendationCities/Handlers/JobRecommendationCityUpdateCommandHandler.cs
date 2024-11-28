using Application.JobRecommendationCities.Commands;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.JobRecommendationCities.Handlers;

sealed class JobRecommendationCityUpdateCommandHandler(IJobRecommendationCityRepository jobRecommendationCityRepository) : IRequestHandler<JobRecommendationCityUpdateCommand, bool>
{
    public async Task<bool> Handle(JobRecommendationCityUpdateCommand command, CancellationToken cancellationToken)
    {
        var existingCities = (await jobRecommendationCityRepository.FindAllAsync(command.JobRecommendationId)).ToList();


        if (command.Cities == null || command.Cities.Count == 0)
        {
            if (existingCities.Count != 0)
                await jobRecommendationCityRepository.DeleteRangeAsync(existingCities);
        }
        else
        {
            // Determine cities to insert and delete
            var citiesToInsert = command.Cities.Except(existingCities.Select(c => c.CityId)).ToList();
            var citiesToDelete = existingCities.Where(c => !command.Cities.Contains(c.CityId)).ToList();

            // Insert new cities
            if (citiesToInsert.Count != 0)
            {
                await jobRecommendationCityRepository.InsertRangeAsync(
                    citiesToInsert.Select(cityId => new JobRecommendationCity
                    {
                        CityId = cityId,
                        JobRecommendationId = command.JobRecommendationId
                    }).ToList()
                );
            }

            // Delete removed cities
            if (citiesToDelete.Count != 0)
            {
                await jobRecommendationCityRepository.DeleteRangeAsync(citiesToDelete);
            }
        }

        return true;
    }
}