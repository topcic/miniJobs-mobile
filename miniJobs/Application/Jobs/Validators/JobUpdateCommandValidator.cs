using Application.Common.Extensions;
using Application.Jobs.Commands;
using Domain.Enums;
using Domain.Interfaces;
using FluentValidation;

namespace Application.Jobs.Validators;

internal class JobUpdateCommandValidator : AbstractValidator<JobUpdateCommand>
{
    private readonly IJobRepository jobRepository;
    private readonly IJobTypeRepository jobTypeRepository;

    public JobUpdateCommandValidator( IJobRepository jobRepository, IJobTypeRepository jobTypeRepository)
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
        this.jobTypeRepository = jobTypeRepository;
    }

    private async Task<bool> ValidateEntity(JobUpdateCommand command)
    {
        var job = await jobRepository.TryFindAsync(command.Request.Id);
        ExceptionExtension.Validate("JOB_NOT_EXIST", () => job == null);
        ExceptionExtension.Validate("CAN_NOT_UPDATE_JOB_IN_THIS_STATUS", () => job.Status == JobStatus.Inactive || job.Status == JobStatus.Completed);


        if (command.Request.JobTypeId.HasValue)
        {
            var jobType = await jobTypeRepository.TryFindAsync(command.Request.JobTypeId.Value);
            ExceptionExtension.Validate("JOB_TYPE_NOT_EXISTS", () => jobType == null);
        }
        return true;
    }
}