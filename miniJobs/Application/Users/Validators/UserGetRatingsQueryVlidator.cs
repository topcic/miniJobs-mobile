using Application.Common.Extensions;
using Domain.Interfaces;
using FluentValidation;

namespace Application.Users.Validators;
public class UserGetRatingsQueryVlidator : AbstractValidator<UserGetRatingsQuery>
{
    private readonly IUserManagerRepository userRepository;
    public UserGetRatingsQueryVlidator(IUserManagerRepository userRepository)
    {
        RuleFor(x => x).MustAsync(async (x, cancellation) => await Validate(x));
        this.userRepository = userRepository;
    }
    private new async Task<bool> Validate(UserGetRatingsQuery query)
    {
        var user = await userRepository.TryFindAsync(query.Id);
        ExceptionExtension.Validate("USER_NOT_EXISTS", () => user == null);
        return true;
    }
}