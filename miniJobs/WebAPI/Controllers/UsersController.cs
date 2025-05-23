﻿using Application.JobRecommendations.Queries;
using Application.Users;
using Application.Users.Commands;
using Application.Users.Models;
using Application.Users.Queries;
using Application.Users.Validators;
using Domain.Entities;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace WebAPI.Controllers;
[Route("api/users")]
[Authorize]
public class UsersController(IMediator mediator) : ControllerBase
{
    private readonly IMediator mediator = mediator;


    [HttpGet("")]
    [ProducesResponseType(typeof(IEnumerable<User>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> GetAll()
    {

        return Ok();
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
    [HttpPatch("{userId}/activate")]
    [ProducesResponseType(typeof(User), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> Activate([FromRoute] int userId)
    {
        return Ok(await mediator.Send(new UserActivateCommand(userId)));
    }
    
    [HttpGet("{userId}")]
    [ProducesResponseType(typeof(User), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> FindUser([FromRoute] int userId)
    {
        return Ok(await mediator.Send(new UserTryFindQuery(userId)));
    }


    
    [HttpPut("{userId}")]
    [Authorize(Roles = "Administrator")]
    [ProducesResponseType(typeof(User), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> UpdateUser([FromRoute] int userId, [FromBody] User user)
    {
        user.Id = userId;
        return Ok(await mediator.Send(new UserUpdateCommand(user)));
    }


    [HttpGet("{userId}/job-recommendations")]
    [Authorize(Roles = "Applicant")]
    [ProducesResponseType(typeof(JobRecommendation), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> FindJob([FromRoute] int userId)
    {
        return Ok(await mediator.Send(new JobRecommendationTryFindQuery(userId)));
    }

    /// <summary>
    /// Forgot password
    /// </summary>
    /// <param name="email"></param>
    /// <returns>Returns result of forgot password command</returns>
    /// <response code="200">Returns boolean result</response>
    /// <response code="400">Bad request</response>
    /// <response code="500">Detailed exception for lower environments.</response>
    [HttpPost("forgotpassword")]
    [AllowAnonymous]
    [ProducesResponseType(typeof(bool), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> ForgotPassword([FromBody] string email)
    {
        return Ok(await mediator.Send(new UserForgotPasswordCommand(email)));
    }

    [HttpPost("password")]
    [AllowAnonymous]
    [ProducesResponseType(typeof(bool), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> ChangePassword([FromBody] UserChangePasswordRequest request)
    {
        return Ok(await mediator.Send(new UserChangePasswordCommand(request)));
    }

    [HttpDelete("{userId}")]
    [ProducesResponseType(typeof(User), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> Delete([FromRoute] int userId)
    {
        return Ok(await mediator.Send(new UserDeleteCommand(userId)));
    }
}