using Application.Common.Extensions;
using Application.Common.Interfaces;
using Application.Ratings.Commands;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;
using System.Transactions;

namespace Application.Ratings.Handlers;

public class RatingInsertCommandHandler : IRequestHandler<RatingInsertCommand, Rating>
{
    private readonly IRatingRepository ratingRepository;
    private readonly IJobApplicationRepository jobApplicationRepository;
    private readonly IJobRepository jobRepository;
    private readonly IEmailSender emailSender;
    private readonly IUserManagerRepository userManagerRepository;


    public RatingInsertCommandHandler(IJobApplicationRepository jobApplicationRepository, IUserManagerRepository userManagerRepository,
        IRatingRepository ratingRepository, IJobRepository jobRepository, IEmailSender emailSender)
    {

        this.jobApplicationRepository = jobApplicationRepository;
        this.ratingRepository = ratingRepository;
        this.jobRepository = jobRepository;
        this.emailSender = emailSender;
        this.userManagerRepository = userManagerRepository;

    }
    public async Task<Rating> Handle(RatingInsertCommand command, CancellationToken cancellationToken)
    {
        using var ts = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);

        JobApplication jobApplication = await jobApplicationRepository.TryFindAsync(command.Request.JobApplicationId);
        ExceptionExtension.Validate("JOB_APPLICATION_NOT_EXISTS", () => jobApplication == null);

        Job job = await jobRepository.TryFindAsync(jobApplication.JobId);
        ExceptionExtension.Validate("CANNOT_RATE_USER_IN_THIS_JOB_STATUS", () => job.Status != Domain.Enums.JobStatus.Active);

        var ratedUser = await userManagerRepository.TryFindAsync(command.Request.RatedUserId);
        ExceptionExtension.Validate("USER_NOT_EXISTS", () => ratedUser == null);

        var isUserAlreadyRated = await ratingRepository.FindOneAsync(x => x.RatedUserId == command.Request.RatedUserId && x.JobApplicationId == command.Request.JobApplicationId);
        ExceptionExtension.Validate("USER_ALREADY_RATED", () => isUserAlreadyRated != null);

        var isCreatorRated = await ratingRepository.FindOneAsync(x => x.RatedUserId == command.UserId.Value && x.JobApplicationId == command.Request.JobApplicationId);

        var rating = command.Request;
        rating.Created = DateTime.UtcNow;
        rating.CreatedBy = command.UserId.Value;
        if (isCreatorRated != null)
        {
            rating.IsActive = true;
            isCreatorRated.IsActive = true;
            await ratingRepository.UpdateAsync(isCreatorRated);
        }
        else
            rating.IsActive = false;

        await ratingRepository.InsertAsync(rating);

        var creator = await userManagerRepository.TryFindAsync(command.UserId.Value);

        await emailSender.SendUserRatingNotificationEmailAsync(creator.FirstName, ratedUser.Email, job.Name);

        ts.Complete();

        return rating;
    }
}