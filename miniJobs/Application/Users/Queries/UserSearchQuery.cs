using Application.Common.Models;
using Application.Common.Queries;
using Domain.Entities;

namespace Application.Users.Queries;

public class UserSearchQuery(Dictionary<string, string> parameters) : QueryBase<SearchResponseBase<User>>
{
    public Dictionary<string, string> Parameters { get; set; } = parameters;
}
