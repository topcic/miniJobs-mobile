using Application.Common.Interfaces;
using Application.JobRecommendations.Commands;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.JobRecommendations.Handlers;

sealed class JobRecommendationUpdateCommandHandler(IJobRecommendationRepository jobRecommendationRepository, IJobRecommendationCityRepository jobRecommendationCityRepository, IJobRecommendationJobTypeRepository jobRecommendationJobTypeRepository, IUnitOfWork unitOfWork) : IRequestHandler<JobRecommendationUpdateCommand, JobRecommendation>
{
    public async Task<JobRecommendation> Handle(JobRecommendationUpdateCommand command, CancellationToken cancellationToken)
    {
        return await unitOfWork.ExecuteAsync(async () =>
        {
            var jobRecommendation = await jobRecommendationRepository.TryFindAsync(command.Id);
            jobRecommendation.LastModified = DateTime.UtcNow;
            jobRecommendation.LastModifiedBy = command.UserId.Value;
            await jobRecommendationRepository.UpdateAsync(jobRecommendation);

            var insertedCites= await jobRecommendationCityRepository.FindAllAsync(jobRecommendation.Id);
            var insertedJobTypes = await jobRecommendationCityRepository.FindAllAsync(jobRecommendation.Id);



            await jobRecommendationCityRepository.InsertRangeAsync(
                command.Request.Cities.Select(cityId => new JobRecommendationCity
                {
                    CityId = cityId,
                    JobRecommendationId = jobRecommendation.Id
                }).ToList()
            );

            if (command.Request.JobTypes?.Any() == true)
                await jobRecommendationJobTypeRepository.InsertRangeAsync(
                command.Request.JobTypes.Select(jobTypeId => new JobRecommendationJobType
                {
                    JobTypeId = jobTypeId,
                    JobRecommendationId = jobRecommendation.Id
                }).ToList()
            );

            return jobRecommendation;
        }, cancellationToken);
    }
}