using Application.Common.Extensions;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Users.Handlers;

public class UserGetRatingsQueryHandler : IRequestHandler<UserGetRatingsQuery, IEnumerable<Rating>>
{
    private readonly IUserManagerRepository userRepository;


    public UserGetRatingsQueryHandler(IUserManagerRepository userRepository)
    {
        this.userRepository = userRepository;
    }


    public async Task<IEnumerable<Rating>> Handle(UserGetRatingsQuery request, CancellationToken cancellationToken)
    {

        var user = await userRepository.TryFindAsync(request.Id);
        ExceptionExtension.Validate("USER_NOT_EXISTS", () => user == null);
        return await userRepository.GetRatings(request.Id);
    }
}