using Application.Common.Extensions;
using Application.Employers.Commands;
using Domain.Interfaces;
using FluentValidation;

namespace Application.Employers.Vlidators;

public class EmployerInsertCommandValidator : AbstractValidator<EmployerInsertCommand>
{
    private readonly IUserManagerRepository userManager;
    public EmployerInsertCommandValidator(ICityRepository cityRepository, IUserManagerRepository userManager)
    {
        RuleFor(x => x.Request.Email)
            .Cascade(CascadeMode.Stop)
            .NotEmpty().OverridePropertyName("Email").WithMessage("EMAIL_IS_REQUIRED")
            .EmailAddress().WithMessage("Nevalidna dužina");

        RuleFor(x => x.Request.Name)
          .Cascade(CascadeMode.Stop)
          .NotEmpty().OverridePropertyName("Name").WithMessage("NAME_IS_REQUIRED")
          .Length(2, 20).WithMessage("NOT_VALID_STRING_LENGHT");

        RuleFor(x => x.Request.StreetAddressAndNumber)
            .Cascade(CascadeMode.Stop)
            .NotEmpty().OverridePropertyName("StreetAddressAndNumber").WithMessage("ADDRESS_IS_REQUIRED")
            .Length(2, 50).WithMessage("NOT_VALID_STRING_LENGHT");

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
            .Length(14, 15).OverridePropertyName("PhoneNumber").WithMessage("NOT_VALID_STRING_LENGHT");

        RuleFor(x => x.Request.CityId)
            .NotNull().OverridePropertyName("CityId").WithMessage("CITY_IS_REQUIRED");

        RuleFor(x => x.Request.IdNumber)
           .Cascade(CascadeMode.Stop)
           .NotEmpty().OverridePropertyName("IdNumber").WithMessage("ID_NUMBER_IS_REQUIRED")
            .Length(13).WithMessage("NOT_VALID_STRING_LENGHT");

        RuleFor(x => x.Request.CompanyPhoneNumber).Cascade(CascadeMode.Stop)
           .NotEmpty().OverridePropertyName("CompanyPhoneNumber").WithMessage("COMPANY_PHONE_NUMBER_IS_REQUIRED")
           .Length(14, 15).WithMessage("NOT_VALID_STRING_LENGHT");

        RuleFor(x => x.Request.CityId).MustAsync(async (id, cancellation) => await cityRepository.TryFindAsync(id) != null).OverridePropertyName("CityId").WithMessage("Grad ne postoji.");
        RuleFor(x => x).MustAsync(async (x, cancellation) => await Validate(x));
        this.userManager = userManager;
    }
    private async Task<bool> Validate(EmployerInsertCommand command)
    {
        var registeredUser = await userManager.TryFindByEmailAsync(command.Request.Email.ToLower());
        ExceptionExtension.Validate("EMAIL_ADDRESS_EXIST", () => registeredUser != null);
        return true;
    }
}