using Application.JobTypes.Queries;
using Domain.Entities;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace WebAPI.Controllers;


[Route("api/jobtypes")]
[Authorize]
public class JobTypesController(IMediator mediator) : ControllerBase
{
    private readonly IMediator mediator = mediator;


    [HttpGet("")]
    [ProducesResponseType(typeof(IEnumerable<JobType>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> FindAllAsync()
    {
        return Ok(await mediator.Send(new JobTypeFindAllQuery()));
    }

}