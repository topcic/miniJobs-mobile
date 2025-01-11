using Application.Common.Interfaces;
using Application.Ratings.Commands;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;
using System.Transactions;

namespace Application.Ratings.Handlers;

public class RatingInsertCommandHandler(IJobApplicationRepository jobApplicationRepository, IUserManagerRepository userManagerRepository,
    IRatingRepository ratingRepository, IJobRepository jobRepository, IEmailSender emailSender) : IRequestHandler<RatingInsertCommand, Rating>
{
    public async Task<Rating> Handle(RatingInsertCommand command, CancellationToken cancellationToken)
    {
        using var ts = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);

        JobApplication jobApplication = await jobApplicationRepository.TryFindAsync(command.Request.JobApplicationId);
        Job job = await jobRepository.TryFindAsync(jobApplication.JobId);
        var ratedUser = await userManagerRepository.TryFindAsync(command.Request.RatedUserId);

        var rating = command.Request;
        rating.Created = DateTime.UtcNow;
        rating.CreatedBy = command.UserId.Value;
        rating.IsActive = true;

        await ratingRepository.InsertAsync(rating);

        var creator = await userManagerRepository.TryFindAsync(command.UserId.Value);

        await emailSender.SendUserRatingNotificationEmailAsync(creator.FirstName, ratedUser.Email, job.Name);

        ts.Complete();

        return rating;
    }
}