﻿using Application.Employers.Commands;
using Application.Employers.Models;
using Application.Employers.Queries;
using Application.Jobs.Queries;
using Application.Users.Models;
using Application.Users.Queries;
using Domain.Entities;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace WebAPI.Controllers;

[Route("api/employers")]
[AllowAnonymous]
public class EmployersController(IMediator mediator) : ControllerBase
{
    private readonly IMediator mediator = mediator;

    [HttpPost]
    [ProducesResponseType(typeof(UserRegistrationResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status422UnprocessableEntity)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> InsertAsync([FromBody] EmployerInsertRequest request)
    {
        return Ok(await mediator.Send(new EmployerInsertCommand(request)));
    }


    [HttpPut("{employerId}")]
    [ProducesResponseType(typeof(UserRegistrationResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status422UnprocessableEntity)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> UpdateAsync([FromRoute] int employerId, [FromBody] EmployerUpdateRequest request)
    {
        return Ok(await mediator.Send(new EmployerUpdateCommand(employerId, request)));
    }

    [HttpGet("{employerId}")]
    [ProducesResponseType(typeof(User), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> FindUser([FromRoute] int employerId)
    {
        return Ok(await mediator.Send(new EmployerTryFindQuery(employerId)));
    }

    [HttpGet("{employerId}/activejobs")]
    [ProducesResponseType(typeof(IEnumerable<Job>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> GetActiveJobs([FromRoute] int employerId)
    {

        return Ok(await mediator.Send(new EmployerGetActiveJobsQuery(employerId)));
    } 

    [HttpGet("{employerId}/jobs")]
    [ProducesResponseType(typeof(IEnumerable<Job>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> GetJobs([FromRoute] int employerId)
    {

        return Ok(await mediator.Send(new JobFindAllForEmployerQuery(employerId)));
    }
}