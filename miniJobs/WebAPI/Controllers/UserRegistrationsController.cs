using Arni.Identity.Abstractions.Models;
using Arni.PublicCallBridge.Application.Users.Commands;
using Arni.PublicCallBridge.Application.Users.Models;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace WebAPI.Controllers;

[Route("api/users/registrations")]
[AllowAnonymous]
public class UserRegistrationsController(IMediator mediator) : ControllerBase
{
    private readonly IMediator mediator = mediator;

    /// <summary>
    /// Register user account
    /// </summary>
    /// <param name="command"></param>
    /// <returns>Returns user registration response or error</returns>
    /// <remarks>
    /// <response code="200">User registration confirmation.</response>
    /// <response code="400">Bad request</response>
    /// <response code="500">Detailed exception for lower environments.</response>
    [HttpPost]
    [ProducesResponseType(typeof(UserRegistrationResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status422UnprocessableEntity)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> UserRegisterAsync([FromBody] UserRegistrationRequest request)
    {
        return Ok(await mediator.Send(new UserRegistrationCommand(request)));
    }

    /// <summary>
    /// Register user account
    /// </summary>
    /// <param name="command"></param>
    /// <returns>Returns user registration response or error</returns>
    /// <remarks>
    /// <response code="200">User registration confirmation.</response>
    /// <response code="400">Bad request</response>
    /// <response code="500">Detailed exception for lower environments.</response>
    [HttpPost]
    [Route("confirmations")]
    [ProducesResponseType(typeof(UserAccountConfirmationResult), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status422UnprocessableEntity)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> UserEmailConfirmationAsync([FromBody] Guid confirmationCode)
    {
        return Ok(await mediator.Send(new UserEmailConfirmationCommand(confirmationCode)));
    }
}