using Application.Applicants.Queries;
using Application.Jobs.Queries;
using Application.Users;
using Application.Users.Commands;
using Application.Users.Models;
using Application.Users.Queries;
using Domain.Dtos;
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

    [HttpGet("{userId}/ratings")]
    [ProducesResponseType(typeof(IEnumerable<Rating>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> GetReatings([FromRoute] int userId)
    {

        return Ok(await mediator.Send(new UserGetRatingsQuery(userId)));
    }

    [HttpGet("{userId}/finishedjobs")]
    [ProducesResponseType(typeof(IEnumerable<Job>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> GetFinishedJobs([FromRoute] int userId)
    {
        return Ok(await mediator.Send(new UserGetFinishedJobsQuery(userId)));
    }

    [HttpPatch("{userId}/photo")]
    [ProducesResponseType(typeof(User), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> AddUserPhoto([FromRoute] int userId, [FromForm] IFormFile photo)
    {
        return Ok(await mediator.Send(new UserUpdatePhotoCommand(userId, photo)));
    }

    [HttpGet("{userId}")]
    [ProducesResponseType(typeof(User), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> FindUser([FromRoute] int userId)
    {
        return Ok(await mediator.Send(new UserTryFindQuery(userId)));
    }
}