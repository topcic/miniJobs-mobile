using Application.Common.Extensions;
using Application.Jobs.Commands;
using Domain.Entities;
using Domain.Enums;
using Domain.Interfaces;
using FluentValidation;

namespace Application.Jobs.Validators;

public class JobCompleteApplicationsCommandValidator : AbstractValidator<JobCompleteApplicationsCommand>
{
    private readonly IJobRepository jobRepository;
    public JobCompleteApplicationsCommandValidator(IJobRepository jobRepository)
    {
        RuleFor(x => x).MustAsync(async (x, cancellation) => await ValidateEntity(x));
        this.jobRepository = jobRepository;
    }

    private async Task<bool> ValidateEntity(JobCompleteApplicationsCommand command)
    {
        Job job = await jobRepository.TryFindAsync(command.JobId);
        ExceptionExtension.Validate("JOB_NOT_EXISTS", () => job == null);
        ExceptionExtension.Validate("NO_ACTIONS_POSSIBLE_BECAUSE_HAS_BEEN_DELETED_BY_ADMIN", () => job.DeletedByAdmin);

        var applicants = (await jobRepository.GetApplicants(command.JobId, command.RoleId)).ToList();

        ExceptionExtension.Validate("JOB_NEED_APPLICANTS", () => applicants.Count() == 0);

        return true;
    }
}