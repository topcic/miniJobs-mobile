using Application.Common.Extensions;
using Application.Users.Commands;
using Domain.Interfaces;
using FluentValidation;

namespace Application.Users.Validators;
public class ApplicantRegistrationCommandValidator : AbstractValidator<RegistrationCommand>
{
    private readonly IUserManagerRepository userManager;
    public ApplicantRegistrationCommandValidator(ICityRepository cityRepository, IUserManagerRepository userManager)
    {
        RuleFor(x => x.Request.Email)
            .Cascade(CascadeMode.Stop)
            .NotEmpty().OverridePropertyName("Email").WithMessage("EMAIL_IS_REQUIRED")
            .EmailAddress().WithMessage("NOT_VALID_STRING_LENGHT");

        RuleFor(x => x.Request.FirstName)
           .Cascade(CascadeMode.Stop)
           .NotEmpty().OverridePropertyName("FirstName").WithMessage("FIRST_NAME_IS_REQUIRED")
           .Length(2, 20).WithMessage("NOT_VALID_STRING_LENGHT");

        RuleFor(x => x.Request.LastName)
            .Cascade(CascadeMode.Stop)
            .NotEmpty().OverridePropertyName("LastName").WithMessage("LAST_NAME_IS_REQUIRED")
            .Length(2, 30).WithMessage("NOT_VALID_STRING_LENGHT");
        RuleFor(x => x.Request.Password)
             .Cascade(CascadeMode.Stop)
             .NotEmpty().OverridePropertyName("Password").WithMessage("PASSWORD_IS_REQUIRED")
             .Length(8, 100).WithMessage("NOT_VALID_STRING_LENGHT");

        RuleFor(x => x.Request.PhoneNumber).Cascade(CascadeMode.Stop)
            .NotEmpty().OverridePropertyName("PhoneNumber").WithMessage("PHONE_NUMBER_IS_REQUIRED")
               .Length(14, 15).OverridePropertyName("PhoneNumber").WithMessage("NOT_VALID_STRING_LENGHT");

        RuleFor(x => x.Request.CityId)
         .NotNull().OverridePropertyName("CityId").WithMessage("CITY_IS_REQUIRED");

        RuleFor(x => x.Request.Gender)
          .NotNull().OverridePropertyName("Gender").WithMessage("GENDER_IS_REQUIRED");

        RuleFor(x => x.Request.CityId).MustAsync(async (id, cancellation) => await cityRepository.TryFindAsync(id) != null).OverridePropertyName("CityId").WithMessage("CITY_NOT_EXIST");
        RuleFor(x => x).MustAsync(async (x, cancellation) => await Validate(x));
        this.userManager = userManager;
    }
    private async Task<bool> Validate(RegistrationCommand command)
    {
        var registeredUser = await userManager.TryFindByEmailAsync(command.Request.Email.ToLower());
        ExceptionExtension.Validate("EMAIL_ADDRESS_EXIST", () => registeredUser != null);

        return true;
    }
}