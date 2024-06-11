using Application.Applicants.Models;
using Application.Applicants.Queries;
using Application.Users.Models;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace WebAPI.Controllers;

[Route("api/applicants")]
[AllowAnonymous]
public class Applicantscontroller(IMediator mediator) : ControllerBase
{
    private readonly IMediator mediator = mediator;

    [HttpGet("search")]
    [ProducesResponseType(typeof(UserRegistrationResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status422UnprocessableEntity)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> InsertAsync(ApplicantSearchRequest request)
    {
        return Ok(await mediator.Send(new ApplicantSearchAsyncQuery(request)));
    }
}