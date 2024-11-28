using Application.Common.Interfaces;
using Application.JobRecommendationCities.Commands;
using Application.JobRecommendationJobTypes.Commands;
using Application.JobRecommendations.Commands;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.JobRecommendations.Handlers;

public class JobRecommendationInsertCommandHandler(IJobRecommendationRepository jobRecommendationRepository, IMediator mediator, IUnitOfWork unitOfWork) : IRequestHandler<JobRecommendationInsertCommand, JobRecommendation>
{
    public async Task<JobRecommendation> Handle(JobRecommendationInsertCommand command, CancellationToken cancellationToken)
    {
        return await unitOfWork.ExecuteAsync(async () =>
        {
            var jobRecommendation = new JobRecommendation
            {
                Created = DateTime.UtcNow,
                CreatedBy = command.UserId.Value
            };
          
            await jobRecommendationRepository.InsertAsync(jobRecommendation);

            if (command.Request.Cities != null && command.Request.Cities.Count != 0)
                await mediator.Send(new JobRecommendationCityInsertCommand(command.Request.Cities, jobRecommendation.Id), cancellationToken);

            if (command.Request.JobTypes != null && command.Request.JobTypes.Count != 0)
                await mediator.Send(new JobRecommendationJobTypeInsertCommand(command.Request.JobTypes, jobRecommendation.Id), cancellationToken);

            return jobRecommendation;
        }, cancellationToken);
    }
}