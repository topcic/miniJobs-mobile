using System.Security.Claims;

namespace Application.Common.Extensions;

/// <summary>
/// User principal extensions
/// </summary>
public static class UserPrincipalExtensions
{ 
    /// <summary>
    /// Get full name of logged in user
    /// </summary>
    /// <param name="user"></param>
    /// <returns></returns>
    public static string GetFullName(this System.Security.Principal.IPrincipal user)
    {
        return $"{user.GetClaim(ClaimTypes.GivenName)} {user.GetClaim(ClaimTypes.Surname)}";
    }

    /// <summary>
    /// Get role id of logged in user
    /// </summary>
    /// <param name="user"></param>
    /// <returns></returns>
    public static string GetRoleId(this System.Security.Principal.IPrincipal user)
    {
        string roleId = user.GetClaim(ClaimTypes.Role);
        return string.IsNullOrEmpty(roleId) ? string.Empty : roleId;
    }

    /// <summary>
    /// Get id of logged in user
    /// </summary>
    /// <param name="user"></param>
    /// <returns></returns>
    public static int? GetUserId(this System.Security.Principal.IPrincipal user)
    {
        string userId = user.GetClaim(ClaimTypes.NameIdentifier);
        return string.IsNullOrEmpty(userId) ? null : int.Parse(userId);
    }
    /// <summary>
    /// Get email logged in user
    /// </summary>
    /// <param name="user"></param>
    /// <returns></returns>
    public static string GetUserEmail(this System.Security.Principal.IPrincipal user)
    {
        return user.GetClaim(ClaimTypes.Email);
    }

    /// <summary>
    /// Get claim by type
    /// </summary>
    /// <param name="user"></param>
    /// <param name="type"></param>
    /// <returns></returns>
    private static string GetClaim(this System.Security.Principal.IPrincipal user, string type)
    {
        Claim claims = ((ClaimsPrincipal)user).Claims.FirstOrDefault(p => p.Type == type);
        return claims?.Value;
    }
}