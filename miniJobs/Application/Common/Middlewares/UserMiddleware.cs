using Application.Common.Context;
using Application.Common.Extensions;
using Microsoft.AspNetCore.Http;

namespace Application.Common.Middlewares;

/// <summary>
/// User Middleware that process claims to get user id
/// and provides as static response
/// </summary>
public class UserMiddleware
{
    private readonly RequestDelegate _next;

    public UserMiddleware(RequestDelegate next)
    {
        _next = next;
    }

    public async Task Invoke(HttpContext context)
    {
        var userId = context.User.GetUserId();
        UserContext.SetUserId(userId);

        var roleId = context.User.GetRoleId();
        UserContext.SetRoleId(roleId);

        await _next.Invoke(context);
    }
}