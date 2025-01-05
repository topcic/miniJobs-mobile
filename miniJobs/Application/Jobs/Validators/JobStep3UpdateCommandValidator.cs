using Application.Common.Extensions;
using Application.Jobs.Commands;
using Domain.Enums;
using Domain.Interfaces;
using FluentValidation;

namespace Application.Jobs.Validators;

public class JobStep3UpdateCommandValidator : AbstractValidator<JobStep3UpdateCommand>
{
    private readonly IJobRepository jobRepository;
    private readonly IQuestionRepository questionRepository;

    public JobStep3UpdateCommandValidator(IJobRepository jobRepository, IQuestionRepository questionRepository)
    {
        RuleFor(x => x.Request.AnswersToPaymentQuestions)
            .NotNull()
            .WithMessage("ANSWERS_TO_PAYMENT_QUESTIONS_IS_REQUIRED")
            .DependentRules(() =>
            {
                RuleForEach(x => x.Request.AnswersToPaymentQuestions)
                    .Must(entry => entry.Value != null && entry.Value.Any())
                    .WithMessage("EACH_PAYMENT_QUESTION_MUST_HAVE_AT_LEAST_ONE_ANSWER");
            });

        RuleFor(x => x.Request.Wage)
     .Cascade(CascadeMode.Stop)
     .NotNull()
     .WithMessage("WAGE_IS_REQUIRED")
     .GreaterThan(0)
     .WithMessage("WAGE_MUST_BE_GREATER_THAN_ZERO")
     .When(IsWageRequired);

        RuleFor(x => x).MustAsync(async (x, cancellation) => await ValidateEntity(x));
        this.jobRepository = jobRepository;
        this.questionRepository = questionRepository;
    }

    private async Task<bool> ValidateEntity(JobStep3UpdateCommand command)
    {
        var job = await jobRepository.TryFindAsync(command.Request.Id);
        ExceptionExtension.Validate("JOB_NOT_EXIST", () => job == null);
        ExceptionExtension.Validate("CAN_NOT_UPDATE_JOB_IN_THIS_STATUS", () => job.Status == JobStatus.Inactive || job.Status == JobStatus.Completed || job.Status == JobStatus.ApplicationsCompleted);
        return true;
    }

    private bool IsWageRequired(JobStep3UpdateCommand command)
    {
        if (command.Request.AnswersToPaymentQuestions == null ||
            !command.Request.AnswersToPaymentQuestions.TryGetValue(2, out var answersForPayment))
        {
            return false;
        }

        var validAnswers = questionRepository.GetAnswersForQuestion("Način plaćanja?");
        var requiredAnswers = validAnswers
            .Where(a => a.Answer == "dnevnica" || a.Answer == "po satu")
            .Select(a => a.Id)
            .ToList();

        return answersForPayment != null && answersForPayment.Intersect(requiredAnswers).Any();
    }
}