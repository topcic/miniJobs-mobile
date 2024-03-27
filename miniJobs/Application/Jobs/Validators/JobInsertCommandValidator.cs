using Application.Jobs.Commands;
using Domain.Interfaces;
using FluentValidation;

namespace Application.Jobs.Validators;

public class JobInsertCommandValidator : AbstractValidator<JobInsertCommand>
{
    public JobInsertCommandValidator(ICityRepository cityRepository)
    {
        RuleFor(x => x.Request.Name).Cascade(CascadeMode.Stop)
            .NotEmpty().OverridePropertyName("Name").WithMessage("Naziv je obavezno polje");
        RuleFor(x => x.Request.StreetAddressAndNumber).Cascade(CascadeMode.Stop)
            .NotEmpty().OverridePropertyName("StreetAddressAndNumber").WithMessage("Adresa i broj ulice je obavezno polje");
        RuleFor(x => x.Request.CityId)
             .NotNull().OverridePropertyName("CityId").WithMessage("Grad je obavezno polje");

        RuleFor(x => x.Request.CityId).MustAsync(async (id, cancellation) => await cityRepository.TryFindAsync(id) != null).OverridePropertyName("CityId").WithMessage("Grad ne postoji.");
    }
}
