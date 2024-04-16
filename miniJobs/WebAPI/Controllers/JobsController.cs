using Application.Jobs.Commands;
using Application.Jobs.Models;
using Domain.Entities;
using Domain.Enums;
using Infrastructure.JobStateMachine;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace WebAPI.Controllers;

[Route("api/jobs")]
public class JobsController(IMediator mediator, BaseState state) : ControllerBase
{
    private readonly IMediator mediator = mediator;
    private readonly BaseState state=state;

 
    [HttpPost("")]
    [ProducesResponseType(typeof(Job), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> PostAsync([FromBody] JobInsertRequest request)
    {
        var initialState = JobState.Initial;
        var initialStateInstance = state.CreateState(initialState);
        return Ok(await initialStateInstance.Insert(request));
    }

    
    //[HttpPut("{jobId}")]
    //[ProducesResponseType(typeof(Job), StatusCodes.Status200OK)]
    //[ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    //[ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    //public async Task<IActionResult> Update([FromRoute] int jobId, [FromForm] JobSaveRequest request)
    //{
    //    request.Id = jobId;
    //    return Ok(await mediator.Send(new PublicCallUpdateCommand(request)));
    //}

}