
using Application.Tokens.Models;
using MediatR;

namespace Application.Tokens.Commands;

/// <summary>
/// Represent mediator auth token request command
/// </summary>
public class AuthTokenCommand : IRequest<AuthTokenResponse>
{
    /// <summary>
    /// Auth token request
    /// </summary>
    public AuthTokenRequest Request { get; set; }

    /// <summary>
    /// Constructs new instance of auth token command
    /// </summary>
    /// <param name="request"></param>
    public AuthTokenCommand(AuthTokenRequest request)
    {
        Request = request;
    }
}