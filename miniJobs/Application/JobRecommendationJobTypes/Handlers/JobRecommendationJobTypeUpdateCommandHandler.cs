using Application.JobRecommendationJobTypes.Commands;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.JobRecommendationJobTypes.Handlers;

sealed class JobRecommendationJobTypeUpdateCommandHandler(IJobRecommendationJobTypeRepository jobRecommendationJobTypeRepository) : IRequestHandler<JobRecommendationJobTypeUpdateCommand, bool>
{
    public async Task<bool> Handle(JobRecommendationJobTypeUpdateCommand command, CancellationToken cancellationToken)
    {
        var existingJobTypes = (await jobRecommendationJobTypeRepository.FindAllAsync(command.JobRecommendationId)).ToList();


        if (command.JobTypes == null || command.JobTypes.Count == 0)
        {
            if (existingJobTypes.Count != 0)
                await jobRecommendationJobTypeRepository.DeleteRangeAsync(existingJobTypes);
        }
        else
        {
            // Determine cities to insert and delete
            var jobtypesToInsert = command.JobTypes.Except(existingJobTypes.Select(c => c.JobTypeId)).ToList();
            var jobTypesToDelete = existingJobTypes.Where(c => !command.JobTypes.Contains(c.JobTypeId)).ToList();

            // Insert new cities
            if (jobtypesToInsert.Count != 0)
            {
                await jobRecommendationJobTypeRepository.InsertRangeAsync(
                    jobtypesToInsert.Select(jobTypeId => new JobRecommendationJobType
                    {
                        JobTypeId = jobTypeId,
                        JobRecommendationId = command.JobRecommendationId
                    }).ToList()
                );
            }

            // Delete removed cities
            if (jobTypesToDelete.Count != 0)
            {
                await jobRecommendationJobTypeRepository.DeleteRangeAsync(jobTypesToDelete);
            }
        }

        return true;
    }
}