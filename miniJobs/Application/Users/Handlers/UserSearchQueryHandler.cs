using Application.Common.Models;
using Application.Users.Queries;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Users.Handlers;

sealed class UserSearchQueryHandler(IUserManagerRepository userManagerRepository) : IRequestHandler<UserSearchQuery, SearchResponseBase<User>>
{
    public async Task<SearchResponseBase<User>> Handle(UserSearchQuery request, CancellationToken cancellationToken)
    {
        var results = new SearchResponseBase<User>();
        
        results.Result = await userManagerRepository.FindAllAsync();
        results.Count =( await userManagerRepository.FindAllAsync()).Count();
        return results;
    }
}