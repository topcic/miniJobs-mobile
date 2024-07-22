using Application.Jobs.Queries;
using Application.Users;
using Application.Users.Commands;
using Application.Users.Models;
using Application.Users.Queries;
using Domain.Entities;
using Infrastructure.JobStateMachine;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace WebAPI.Controllers;
[Route("api/users")]
public class UsersController(IMediator mediator, BaseState state) : ControllerBase
{
    private readonly IMediator mediator = mediator;
    private readonly BaseState state = state;


    [HttpGet("")]
    [ProducesResponseType(typeof(IEnumerable<User>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> GetAll()
    {

        return Ok();
    }

    [HttpPost("")]
    [ProducesResponseType(typeof(User), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status422UnprocessableEntity)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> PostAsync([FromBody] UserSaveRequest request)
    {
        return Ok(await mediator.Send(new UserInsertCommand(request)));
    }

    [HttpGet("ratings/{userId}")]
    [ProducesResponseType(typeof(IEnumerable<User>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> GetReatings([FromRoute] int userId)
    {

        return Ok(await mediator.Send(new UserGetRatingsQuery(userId)));
    }

    [HttpGet("finishedjobs/{userId}")]
    [ProducesResponseType(typeof(IEnumerable<User>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> GetFinishedJobs([FromRoute] int userId)
    {

        return Ok(await mediator.Send(new UserGetFinishedJobsQuery(userId)));
    }
}