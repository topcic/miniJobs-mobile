using Application.Common.Interfaces;
using Application.JobRecommendationCities.Commands;
using Application.JobRecommendationJobTypes.Commands;
using Application.JobRecommendations.Commands;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.JobRecommendations.Handlers;

sealed class JobRecommendationUpdateCommandHandler(IJobRecommendationRepository jobRecommendationRepository, IMediator mediator, IUnitOfWork unitOfWork) : IRequestHandler<JobRecommendationUpdateCommand, JobRecommendation>
{
    public async Task<JobRecommendation> Handle(JobRecommendationUpdateCommand command, CancellationToken cancellationToken)
    {
        return await unitOfWork.ExecuteAsync(async () =>
        {
            var jobRecommendation = await jobRecommendationRepository.TryFindAsync(command.Id);
            jobRecommendation.LastModified = DateTime.UtcNow;
            jobRecommendation.LastModifiedBy = command.UserId.Value;
            await jobRecommendationRepository.UpdateAsync(jobRecommendation);

            await mediator.Send(new JobRecommendationCityUpdateCommand(command.Request.Cities, jobRecommendation.Id));
            await mediator.Send(new JobRecommendationJobTypeUpdateCommand(command.Request.JobTypes, jobRecommendation.Id));

            return jobRecommendation;
        }, cancellationToken);
    }
}