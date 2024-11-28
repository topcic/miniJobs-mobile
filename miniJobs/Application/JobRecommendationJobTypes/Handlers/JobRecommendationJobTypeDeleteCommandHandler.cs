using Application.JobRecommendationJobTypes.Commands;
using Domain.Interfaces;
using MediatR;

namespace Application.JobRecommendationJobTypes.Handlers;

sealed class JobRecommendationJobTypeDeleteCommandHandler(IJobRecommendationJobTypeRepository jobRecommendationJobTypeRepository) : IRequestHandler<JobRecommendationJobTypeDeleteCommand, bool>
{
    public async Task<bool> Handle(JobRecommendationJobTypeDeleteCommand command, CancellationToken cancellationToken)
    {
        var existingJobTypes = (await jobRecommendationJobTypeRepository.FindAllAsync(command.JobRecommendationId)).ToList();

        if (existingJobTypes.Count != 0)
            await jobRecommendationJobTypeRepository.DeleteRangeAsync(existingJobTypes);

        return true;
    }
}