using Application.Jobs.Commands;
using Domain.Interfaces;
using FluentValidation;

namespace Application.Jobs.Validators;

public class JobInsertCommandValidator : AbstractValidator<JobInsertCommand>
{
    public JobInsertCommandValidator(ICityRepository cityRepository)
    {
        RuleFor(x => x.Request.Name).Cascade(CascadeMode.Stop)
                .NotEmpty().OverridePropertyName("Name").WithMessage("NAME_IS_REQUIRED");
        RuleFor(x => x.Request.Description).Cascade(CascadeMode.Stop)
          .NotEmpty().OverridePropertyName("Description").WithMessage("DESCRIPTION_IS_REQUIRED");
        RuleFor(x => x.Request.StreetAddressAndNumber).Cascade(CascadeMode.Stop)
            .NotEmpty().OverridePropertyName("StreetAddressAndNumber").WithMessage("STREETADDRESSANDNUMBER_IS_REQUIRED");
        RuleFor(x => x.Request.CityId)
             .NotNull().OverridePropertyName("CityId").WithMessage("CITY_IS_REQUIRED");

        RuleFor(x => x.Request.CityId).MustAsync(async (id, cancellation) => await cityRepository.TryFindAsync(id) != null).OverridePropertyName("CityId").WithMessage("Grad ne postoji.");
    }
}
