using Application.Common.Extensions;
using Application.Jobs.Commands;
using Domain.Enums;
using Domain.Interfaces;
using FluentValidation;

namespace Application.Jobs.Validators;

public class JobStep1UpdateCommandValidator : AbstractValidator<JobStep1UpdateCommand>
{
    private readonly IJobRepository jobRepository;

    public JobStep1UpdateCommandValidator(IJobRepository jobRepository)
    {
        RuleFor(x => x.Request.Name).Cascade(CascadeMode.Stop)
          .NotEmpty().OverridePropertyName("Name").WithMessage("NAME_IS_REQUIRED");
        RuleFor(x => x.Request.Description).Cascade(CascadeMode.Stop)
          .NotEmpty().OverridePropertyName("Description").WithMessage("DESCRIPTION_IS_REQUIRED");
        RuleFor(x => x.Request.StreetAddressAndNumber).Cascade(CascadeMode.Stop)
            .NotEmpty().OverridePropertyName("StreetAddressAndNumber").WithMessage("STREETADDRESSANDNUMBER_IS_REQUIRED");
        RuleFor(x => x.Request.CityId)
             .NotNull().OverridePropertyName("CityId").WithMessage("CITY_IS_REQUIRED");
        RuleFor(x => x).MustAsync(async (x, cancellation) => await ValidateEntity(x));
        this.jobRepository = jobRepository;
    }

    private async Task<bool> ValidateEntity(JobStep1UpdateCommand command)
    {
        var job = await jobRepository.TryFindAsync(command.Request.Id);
        ExceptionExtension.Validate("JOB_NOT_EXIST", () => job == null);
        ExceptionExtension.Validate("CAN_NOT_UPDATE_JOB_IN_THIS_STATUS", () => job.Status == JobStatus.Inactive || job.Status == JobStatus.Completed || job.Status == JobStatus.ApplicationsCompleted);

        return true;
    }
}