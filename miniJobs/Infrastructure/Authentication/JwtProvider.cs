using Application.Common.Extensions;
using Application.Common.Interfaces;
using Application.Tokens.Models;
using Infrastructure.Options;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace Infrastructure.Authentication;

internal sealed class JwtProvider(IOptions<JwtOptions> options, ITokenRepository tokenRepository) : IJwtProvider
{
    private readonly JwtOptions options = options.Value;
    private readonly ITokenRepository tokenRepository = tokenRepository;
    public async Task<AuthTokenResponse> GenerateTokenAndRefreshToken(User user, Role role)
    {
        AuthTokenResponse token = new();

        var claims = new Claim[] {
                new(ClaimTypes.Role, role.Id.ToString()),
                new(ClaimTypes.NameIdentifier,user.Id.ToString()),
                new(ClaimTypes.Email,user.Email),
                new(ClaimTypes.GivenName, user.FirstName!),
                new(ClaimTypes.Surname, user.LastName!)
        };
        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(options.SecretKey));
        DateTime issuedAt = DateTime.UtcNow;
        DateTime validTo = issuedAt.AddMinutes(options.ExpirationTime);

        var jwt = new JwtSecurityToken(issuer: options.Issuer,
            audience: options.Audience,
            claims: claims,
            notBefore: DateTime.UtcNow,
            expires: validTo,
            signingCredentials: new SigningCredentials(key, SecurityAlgorithms.HmacSha256)
        );

        token.ExpiresIn = (validTo - issuedAt).TotalSeconds;
        token.AccessToken = new JwtSecurityTokenHandler().WriteToken(jwt);
        token.RefreshToken = Guid.NewGuid().ToString("N");


        RefreshToken refreshToken = new RefreshToken();
        refreshToken.Id = token.RefreshToken;
        refreshToken.ExpireIn = DateTime.UtcNow.AddMinutes(options.RefreshTime);
        refreshToken.IssuedAt = issuedAt;
        refreshToken.UserId = user.Id;
        refreshToken.Token = token.AccessToken;
        await tokenRepository.InsertAsync(refreshToken);

        return token;
    }
    public async Task<RefreshToken> ValidateRefreshToken(string refreshToken)
    {
        RefreshToken receivedToken = await tokenRepository.FindOneAsync(x => x.Id == refreshToken);
        ExceptionExtension.Validate("REFRESH_TOKEN_DOES_NOT_EXIST", () => receivedToken == null);
        if (receivedToken.ExpireIn < DateTime.UtcNow)
        {
            ExceptionExtension.Validate("REFRESH_TOKEN_EXPIRED", () => true);
        }
        return receivedToken;
    }
}
