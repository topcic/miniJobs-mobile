using Application.Common.Extensions;
using Application.Jobs.Commands;
using Domain.Enums;
using Domain.Interfaces;
using FluentValidation;

namespace Application.Jobs.Validators;

public class JobStep2UpdateCommandValidator : AbstractValidator<JobStep2UpdateCommand>
{
    private readonly IJobRepository jobRepository;
    private readonly IJobTypeRepository jobTypeRepository;

    public JobStep2UpdateCommandValidator(IJobRepository jobRepository, IJobTypeRepository jobTypeRepository)
    {
        RuleFor(x => x.Request.JobSchedule)
           .NotNull()
           .WithMessage("JOB_SCHEDULE_IS_REQUIRED")
           .DependentRules(() =>
           {
               RuleFor(x => x.Request.JobSchedule.QuestionId)
                   .GreaterThan(0)
                   .WithMessage("JOB_SCHEDULE_QUESTION_ID_MUST_BE_GREATER_THAN_ZERO");

               RuleFor(x => x.Request.JobSchedule.Answers)
                   .NotNull()
                   .WithMessage("JOB_SCHEDULE_ANSWERS_IS_REQUIRED")
                   .Must(answers => answers.Any())
                   .WithMessage("JOB_SCHEDULE_ANSWERS_CANNOT_BE_EMPTY");
           });

        RuleFor(x => x.Request.ApplicationsDuration)
          .NotNull()
          .WithMessage("APPLICATIONS_DURATION_IS_REQUIRED")
          .GreaterThan(0)
          .WithMessage("APPLICATIONS_DURATION_MUST_BE_GREATER_THAN_ZERO");

        RuleFor(x => x.Request.RequiredEmployees)
            .NotNull()
            .WithMessage("REQUIRED_EMPLOYEES_IS_REQUIRED")
            .GreaterThan(0)
            .WithMessage("REQUIRED_EMPLOYEES_MUST_BE_GREATER_THAN_ZERO");
        RuleFor(x => x.Request.JobTypeId)
             .NotNull().OverridePropertyName("JobTypeId").WithMessage("JOB_TYPE_IS_REQUIRED");
        RuleFor(x => x).MustAsync(async (x, cancellation) => await ValidateEntity(x));
        this.jobRepository = jobRepository;
        this.jobTypeRepository = jobTypeRepository;
    }

    private async Task<bool> ValidateEntity(JobStep2UpdateCommand command)
    {
        var job = await jobRepository.TryFindAsync(command.Request.Id);
        ExceptionExtension.Validate("JOB_NOT_EXIST", () => job == null);
        ExceptionExtension.Validate("CAN_NOT_UPDATE_JOB_IN_THIS_STATUS", () => job.Status == JobStatus.Inactive || job.Status == JobStatus.Completed || job.Status == JobStatus.ApplicationsCompleted);

        var jobType = await jobTypeRepository.TryFindAsync(command.Request.JobTypeId.Value);
        ExceptionExtension.Validate("JOB_TYPE_NOT_EXISTS", () => jobType == null);
        return true;
    }
}