namespace Application.Common.Context;

/// <summary>
/// Provide User Context that includes requested UserId and RoleId
/// </summary>
public static class UserContext
{
    private static readonly AsyncLocal<int?> UserId = new();
    private static readonly AsyncLocal<string?> RoleId = new();

    /// <summary>
    /// Set user identifier
    /// </summary>
    /// <param name="userId"></param>
    /// <exception cref="InvalidOperationException"></exception>
    public static void SetUserId(int? userId)
    {
        if (userId is null)
        {
            return;
        }

        if (UserId.Value is not null)
        {
            throw new InvalidOperationException("User id is already set");
        }

        UserId.Value = userId;
    }

    /// <summary>
    /// Set user role
    /// </summary>
    /// <param name="roleId"></param>
    /// <exception cref="InvalidOperationException"></exception>
    public static void SetRoleId(string? roleId)
    {
        if (roleId is null)
        {
            return;
        }

        if (RoleId.Value is not null)
        {
            throw new InvalidOperationException("Role id is already set");
        }

        RoleId.Value = roleId;
    }

    /// <summary>
    /// Returns User Id if exists, otherwise it will be null
    /// </summary>
    /// <returns></returns>
    public static int? GetUserId()
    {
        return UserId.Value;
    }

    /// <summary>
    /// Returns User Id if exists, otherwise it will be null
    /// </summary>
    /// <returns></returns>
    public static string GetRoleId()
    {
        return RoleId.Value;
    }
}
