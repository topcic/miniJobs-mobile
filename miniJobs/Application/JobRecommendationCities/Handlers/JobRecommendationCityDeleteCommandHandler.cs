using Application.JobRecommendationCities.Commands;
using Domain.Interfaces;
using MediatR;

namespace Application.JobRecommendationCities.Handlers;

sealed class JobRecommendationCityDeleteCommandHandler(IJobRecommendationCityRepository jobRecommendationCityRepository) : IRequestHandler<JobRecommendationCityDeleteCommand, bool>
{
    public async Task<bool> Handle(JobRecommendationCityDeleteCommand command, CancellationToken cancellationToken)
    {
        var existingCities = (await jobRecommendationCityRepository.FindAllAsync(command.JobRecommendationId)).ToList();

        if (existingCities.Count != 0)
            await jobRecommendationCityRepository.DeleteRangeAsync(existingCities);
        
        return true;
    }
}