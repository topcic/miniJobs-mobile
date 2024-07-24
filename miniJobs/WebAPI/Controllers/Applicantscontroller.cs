using Application.Applicants.Models;
using Application.Applicants.Queries;
using Application.Common.Models;
using Application.Users.Models;
using Domain.Entities;
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
    [ProducesResponseType(typeof(SearchResponseBase<Job>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status422UnprocessableEntity)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> SearchAsync(ApplicantSearchRequest request)
    {
        return Ok(await mediator.Send(new ApplicantSearchAsyncQuery(request)));
    }

    [HttpGet("appliedjobs")]
    [ProducesResponseType(typeof(IEnumerable<Job>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status422UnprocessableEntity)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> GetAppliedJobs()
    {
        return Ok(await mediator.Send(new ApplicantGetAppliedJobsQuery()));
    }

    [HttpGet("savedjobs")]
    [ProducesResponseType(typeof(IEnumerable<Job>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status422UnprocessableEntity)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> GetSavedJobs()
    {
        return Ok(await mediator.Send(new ApplicantGetSavedJobsQuery()));
    }
}