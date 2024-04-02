using Application.Users.Commands;
using Domain.Entities;
using MediatR;

namespace Application.Users.Handlers;

internal class UserInsertCommandHandler : IRequestHandler<UserInsertCommand, User>
{
    public Task<User> Handle(UserInsertCommand request, CancellationToken cancellationToken)
    {
        throw new NotImplementedException();
    }
}
