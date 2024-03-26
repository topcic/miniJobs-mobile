
using Application.Tokens.Models;
using Domain.Entities;

namespace Application.Common.Interfaces;

public interface IJwtProvider
{
    Task<AuthTokenResponse> GenerateTokenAndRefreshToken(User user, Role role);
    Task<RefreshToken> ValidateRefreshToken(string refreshToken);

}
