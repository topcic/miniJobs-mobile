using Application.Tokens.Commands;
using Application.Tokens.Models;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace WebAPI.Controllers;

/// <summary>
/// Provides JWT token
/// </summary>
[AllowAnonymous]
[Route("api/tokens")]
public class TokensController(IMediator mediator) : ControllerBase
{
    private readonly IMediator mediator = mediator;

    /// <summary>
    /// Provides a token for given request
    /// </summary>
    /// <param name="request"></param>
    /// <returns>Returns token or error</returns>
    [HttpPost("")]
    [ProducesResponseType(typeof(AuthTokenResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> AuthTokenAsync([FromBody] AuthTokenRequest request)
    {
        return Ok(await mediator.Send(new AuthTokenCommand(request)));
    }
}