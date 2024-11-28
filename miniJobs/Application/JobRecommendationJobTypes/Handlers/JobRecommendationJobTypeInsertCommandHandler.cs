using Application.JobRecommendationJobTypes.Commands;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.JobRecommendationJobTypes.Handlers;

sealed class JobRecommendationJobTypeInsertCommandHandler(IJobRecommendationJobTypeRepository jobRecommendationJobTypeRepository) : IRequestHandler<JobRecommendationJobTypeInsertCommand, bool>
{
    public async Task<bool> Handle(JobRecommendationJobTypeInsertCommand command, CancellationToken cancellationToken)
    {
        await jobRecommendationJobTypeRepository.InsertRangeAsync(
            command.JobTypes.Select(jobTypeId => new JobRecommendationJobType
            {
                JobTypeId = jobTypeId,
                JobRecommendationId = command.JobRecommendationId
            }).ToList()
        );

        return true;
    }
}