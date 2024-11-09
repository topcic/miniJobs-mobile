using Application.Common.Extensions;
using Application.Jobs.Commands;
using Domain.Interfaces;
using FluentValidation;

namespace Application.Jobs.Validators;

public class JobSaveCommandValidator : AbstractValidator<JobSaveCommand>
{
    private readonly IJobRepository jobRepository;
    private readonly ISavedJobRepository savedJobRepository;

    public JobSaveCommandValidator(ISavedJobRepository savedJobRepository, IJobRepository jobRepository)
    {
        RuleFor(x => x).MustAsync(async (x, cancellation) => await ValidateEntity(x));
        this.savedJobRepository = savedJobRepository;
        this.jobRepository = jobRepository;
    }

    private async Task<bool> ValidateEntity(JobSaveCommand command)
    {
        var job = await jobRepository.TryFindAsync(command.Id);
        ExceptionExtension.Validate("JOB_NOT_EXIST", () => job == null); 
        var isJobSaved = await savedJobRepository.FindOneAsync(x => x.CreatedBy == command.UserId.Value && x.JobId == command.Id && x.IsDeleted == false);
        ExceptionExtension.Validate("JOB_IS_ALREADY_SAVED", () => isJobSaved != null);
        ExceptionExtension.Validate("JOB_IS_COMPLETED", () => job.Status == Domain.Enums.JobStatus.Completed);
        ExceptionExtension.Validate("IT_IS_NOT_POSSIBLE_TO_SAVE_JOB", () => job.Status != Domain.Enums.JobStatus.Active);
        return true;
    }
}