using Application.Common.Interfaces;
using Application.JobRecommendationCities.Commands;
using Application.JobRecommendationJobTypes.Commands;
using Application.JobRecommendations.Commands;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.JobRecommendations.Handlers;

sealed class JobRecommendationDeleteCommandHandler(IJobRecommendationRepository jobRecommendationRepository, IMediator mediator, IUnitOfWork unitOfWork) : IRequestHandler<JobRecommendationDeleteCommand, JobRecommendation>
{
    public async Task<JobRecommendation> Handle(JobRecommendationDeleteCommand command, CancellationToken cancellationToken)
    {
        return await unitOfWork.ExecuteAsync(async () =>
        {
            var jobRecommendation = await jobRecommendationRepository.TryFindAsync(command.Id);

            await mediator.Send(new JobRecommendationJobTypeDeleteCommand(jobRecommendation.Id), cancellationToken);
            await mediator.Send(new JobRecommendationCityDeleteCommand(jobRecommendation.Id), cancellationToken);

            await jobRecommendationRepository.DeleteAsync(jobRecommendation);
            return jobRecommendation;
        }, cancellationToken);
    }
}