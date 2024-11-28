using Application.Common.Extensions;
using Application.JobRecommendations.Commands;
using Domain.Interfaces;
using FluentValidation;

namespace Application.JobRecommendations.Validators;

public class JobRecommendationDeleteCommandValidator : AbstractValidator<JobRecommendationDeleteCommand>
{
    private readonly IJobRecommendationRepository jobRecommendationRepository;

    public JobRecommendationDeleteCommandValidator(IJobRecommendationRepository jobRecommendationRepository)
    {
        RuleFor(x => x).MustAsync(async (x, cancellation) => await ValidateEntity(x));
        this.jobRecommendationRepository = jobRecommendationRepository;
    }

    private async Task<bool> ValidateEntity(JobRecommendationDeleteCommand command)
    {
        var jobRecommendation = await jobRecommendationRepository.TryFindAsync(command.Id);
        ExceptionExtension.Validate("JOB_RECOMMENDATION_NOT_EXISTS", () => jobRecommendation == null);

        return true;
    }
}