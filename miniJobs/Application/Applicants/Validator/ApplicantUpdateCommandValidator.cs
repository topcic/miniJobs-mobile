using Application.Applicants.Commands;
using FluentValidation;

namespace Application.Applicants.Validator;

public class ApplicantUpdateCommandValidator : AbstractValidator<ApplicantUpdateCommand>
{
    public ApplicantUpdateCommandValidator()
    {
        RuleFor(x => x.Request.FirstName).Cascade(CascadeMode.Stop)
            .NotEmpty().OverridePropertyName("FirstName").WithMessage("FIRST_NAME_IS_REQUIRED");
        RuleFor(x => x.Request.LastName).Cascade(CascadeMode.Stop)
            .NotEmpty().OverridePropertyName("LastName").WithMessage("LAST_NAME_IS_REQUIRED");
        RuleFor(x => x.Request.CityId).Cascade(CascadeMode.Stop)
           .NotEmpty().OverridePropertyName("CityId").WithMessage("CITY_IS_REQUIRED");
        RuleFor(x => x.Request.PhoneNumber).NotEmpty().OverridePropertyName("PhoneNumber").WithMessage("PHOTO_NUMBER_IS_REQUIRED")
             .Length(13, 15).OverridePropertyName("PhoneNumber").WithMessage("NOT_VALID_STRING_LENGHT");

    }
}