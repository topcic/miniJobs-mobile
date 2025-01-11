using Application.Common.Extensions;
using Application.Users.Queries;
using Domain.Interfaces;
using FluentValidation;

namespace Application.Users.Validators;
public class UserGetFinishedJobsQueryValidator : AbstractValidator<UserGetFinishedJobsQuery>
{
    private readonly IUserManagerRepository userRepository;
    public UserGetFinishedJobsQueryValidator(IUserManagerRepository userRepository)
    {
        RuleFor(x => x).MustAsync(async (x, cancellation) => await Validate(x));
        this.userRepository = userRepository;
    }
    private new async Task<bool> Validate(UserGetFinishedJobsQuery query)
    {
        var user = await userRepository.TryFindAsync(query.Id);
        ExceptionExtension.Validate("USER_NOT_EXISTS", () => user == null);
        return true;
    }
}