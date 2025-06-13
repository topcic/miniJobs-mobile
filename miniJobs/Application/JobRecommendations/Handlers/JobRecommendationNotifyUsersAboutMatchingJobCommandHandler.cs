using Application.Common;
using Application.JobRecommendations.Commands;
using Application.JobRecommendations.Models;
using Domain.Interfaces;
using MediatR;

namespace Application.JobRecommendations.Handlers;

sealed class JobRecommendationNotifyUsersAboutMatchingJobCommandHandler(IJobRecommendationRepository jobRecommendationRepository,
    IRabbitMQProducer rabbitMQProducer) : IRequestHandler<JobRecommendationNotifyUsersAboutMatchingJobCommand, bool>
{
    public async Task<bool> Handle(JobRecommendationNotifyUsersAboutMatchingJobCommand command, CancellationToken cancellationToken)
    {

        var users = await jobRecommendationRepository.GetUsersByMatchingJobRecommendationsAsync(command.JobId);
        foreach (var user in users)
        {
            var mail = new JobRecommendationMail
            {
                FullName = $"{user.FirstName} {user.LastName}",
                Mail = user.Email,
                JobName = command.JobName
            };
            rabbitMQProducer.SendMessage(mail);
        }
        return true;

    }
}