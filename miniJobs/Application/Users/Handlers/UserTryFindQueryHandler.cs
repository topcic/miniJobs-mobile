using Application.Users.Queries;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Users.Handlers;

public class UserTryFindQueryHandler(IUserManagerRepository userManagerRepository) : IRequestHandler<UserTryFindQuery, User>
{
    public async Task<User> Handle(UserTryFindQuery request, CancellationToken cancellationToken)
    {
        var user = await userManagerRepository.TryFindAsync(request.Id);
        return user;
    }
}