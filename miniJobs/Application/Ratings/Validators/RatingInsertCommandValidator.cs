using Application.Common.Extensions;
using Application.Ratings.Commands;
using Domain.Entities;
using Domain.Enums;
using Domain.Interfaces;
using FluentValidation;

namespace Application.Ratings.Validators;

public class RatingInsertCommandValidator : AbstractValidator<RatingInsertCommand>
{
    private readonly IJobRepository jobRepository;
    private readonly IJobApplicationRepository jobApplicationRepository;
    private readonly IRatingRepository ratingRepository;

    public RatingInsertCommandValidator(IJobRepository jobRepository, IJobApplicationRepository jobApplicationRepository, IRatingRepository ratingRepository)
    {
        RuleFor(x => x).MustAsync(async (x, cancellation) => await ValidateEntity(x));
        this.jobRepository = jobRepository;
        this.jobApplicationRepository = jobApplicationRepository;
        this.ratingRepository = ratingRepository;
    }

    private async Task<bool> ValidateEntity(RatingInsertCommand command)
    {
        var jobApplication= await jobApplicationRepository.TryFindAsync(command.Request.JobApplicationId);
        ExceptionExtension.Validate("JOB_APPLICATION_NOT_EXISTS", () => jobApplication == null);
        ExceptionExtension.Validate("NOT_ALLOWED_TO_RATE", () => jobApplication.Status != JobApplicationStatus.Accepted);
        Job job = await jobRepository.TryFindAsync(jobApplication.JobId);
        ExceptionExtension.Validate("JOB_NOT_COMPLETED", () => job.Status != JobStatus.Completed);

        command.Request.RatedUserId = job.CreatedBy == command.UserId.Value ? jobApplication.CreatedBy.Value 
                                      : jobApplication.CreatedBy.Value == command.UserId.Value ? job.CreatedBy.Value : jobApplication.CreatedBy.Value;
        var rating = await ratingRepository.FindOneAsync(x=>x.JobApplicationId== command.Request.JobApplicationId && x.RatedUserId == command.Request.RatedUserId);
        ExceptionExtension.Validate("ALREADY_RATED", () => rating!=null);
        return true;
    }
}