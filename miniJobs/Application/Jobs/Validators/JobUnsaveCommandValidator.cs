using Application.Common.Extensions;
using Application.Jobs.Commands;
using Domain.Interfaces;
using FluentValidation;

namespace Application.Jobs.Validators;

public class JobUnsaveCommandValidator : AbstractValidator<JobUnsaveCommand>
{
    private readonly ISavedJobRepository savedJobRepository;

    public JobUnsaveCommandValidator(ISavedJobRepository savedJobRepository)
    {
        RuleFor(x => x).MustAsync(async (x, cancellation) => await ValidateEntity(x));
        this.savedJobRepository = savedJobRepository;
    }

    private async Task<bool> ValidateEntity(JobUnsaveCommand command)
    {
        var isJobSaved = await savedJobRepository.FindOneAsync(x => x.CreatedBy == command.UserId.Value && x.JobId == command.JobId && x.IsDeleted == false);
        ExceptionExtension.Validate("JOB_IS_NOT_SAVED", () => isJobSaved == null);
        return true;
    }
}