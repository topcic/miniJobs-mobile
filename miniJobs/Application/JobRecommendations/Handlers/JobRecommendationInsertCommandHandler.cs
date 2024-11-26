using Application.Common.Interfaces;
using Application.JobRecommendations.Commands;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.JobRecommendations.Handlers;

public class JobRecommendationInsertCommandHandler(IJobRecommendationRepository jobRecommendationRepository, IJobRecommendationCityRepository jobRecommendationCityRepository, IJobRecommendationJobTypeRepository jobRecommendationJobTypeRepository, IUnitOfWork unitOfWork) : IRequestHandler<JobRecommendationInsertCommand, JobRecommendation>
{
    public async Task<JobRecommendation> Handle(JobRecommendationInsertCommand command, CancellationToken cancellationToken)
    {
        return await unitOfWork.ExecuteAsync(async () =>
        {
            var jobRecommendation = JobRecommendation.Create(command.UserId.Value);

            await jobRecommendationRepository.InsertAsync(jobRecommendation);
            if (command.Request.Cities?.Any() == true)
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