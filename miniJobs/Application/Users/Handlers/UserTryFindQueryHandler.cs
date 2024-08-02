using Application.Common.Extensions;
using Application.Users.Queries;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Users.Handlers;

public class UserTryFindQueryHandler : IRequestHandler<UserTryFindQuery, User>
{
    private readonly IUserManagerRepository userManagerRepository;

    public UserTryFindQueryHandler(IUserManagerRepository userManagerRepository)
    {
        this.userManagerRepository = userManagerRepository;
    }

    public async Task<User> Handle(UserTryFindQuery request, CancellationToken cancellationToken)
    {

        var user = await userManagerRepository.TryFindAsync(request.Id);
        ExceptionExtension.Validate("USER_NOT_EXISTS", () => user == null);
        return user;
    }
}