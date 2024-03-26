
using Application.Tokens.Models;
using MediatR;

namespace Application.Tokens.Commands;

public class AuthTokenCommand(AuthTokenRequest request) : IRequest<AuthTokenResponse>
{
    public AuthTokenRequest Request { get; set; } = request;
}