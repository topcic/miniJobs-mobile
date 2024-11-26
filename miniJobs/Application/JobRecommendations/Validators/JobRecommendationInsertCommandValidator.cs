using Application.Common.Extensions;
using Application.JobRecommendations.Commands;
using Domain.Interfaces;
using FluentValidation;

namespace Application.JobRecommendations.Validators;

public class JobRecommendationInsertCommandValidator:AbstractValidator<JobRecommendationInsertCommand>
{
    private readonly IJobRecommendationRepository jobRecommendationRepository;

    public JobRecommendationInsertCommandValidator(IJobRecommendationRepository jobRecommendationRepository)
    {
        RuleFor(x => x).MustAsync(async (x, cancellation) => await ValidateEntity(x));
        this.jobRecommendationRepository = jobRecommendationRepository;
    }

    private async Task<bool> ValidateEntity(JobRecommendationInsertCommand command)
    {
        var jobRecommendation = await jobRecommendationRepository.FindOneAsync(x => x.CreatedBy == command.UserId.Value);
        ExceptionExtension.Validate("JOB_RECOMMENDATION_ALREADY_EXISTS", () => jobRecommendation != null);
        ExceptionExtension.Validate("JOB_RECOMMENDATION_NEED_TO_HAVE_AT_LEAST_ONE_CITY_OR_JOB_TYPE", () => command.Request.Cities.Count == 0 && command.Request.JobTypes.Count == 0);

        return true;
    }
}