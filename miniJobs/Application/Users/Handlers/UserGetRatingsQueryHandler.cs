using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Users.Handlers;

public class UserGetRatingsQueryHandler(IUserManagerRepository userRepository) : IRequestHandler<UserGetRatingsQuery, IEnumerable<Rating>>
{
    public async Task<IEnumerable<Rating>> Handle(UserGetRatingsQuery request, CancellationToken cancellationToken)
    {
        var user = await userRepository.TryFindAsync(request.Id);
        return await userRepository.GetRatings(request.Id);
    }
}