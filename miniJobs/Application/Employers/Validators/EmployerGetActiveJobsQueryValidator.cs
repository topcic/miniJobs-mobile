using Application.Common.Extensions;
using Application.Employers.Queries;
using Domain.Interfaces;
using FluentValidation;

namespace Application.Employers.Validators;

public class EmployerGetActiveJobsQueryValidator : AbstractValidator<EmployerGetActiveJobsQuery>
{
    private readonly IEmployerRepository employerRepository;
    public EmployerGetActiveJobsQueryValidator(IEmployerRepository employerRepository)
    {
        RuleFor(x => x).MustAsync(async (x, cancellation) => await Validate(x));
        this.employerRepository = employerRepository;
    }
    private async Task<bool> Validate(EmployerGetActiveJobsQuery command)
    {
        var employer = await employerRepository.TryFindAsync(command.EmployerId);
        ExceptionExtension.Validate("EMPOLOYER_NOT_EXISTS", () => employer == null);
        return true;
    }
}