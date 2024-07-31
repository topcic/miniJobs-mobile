using Application.Applicants.Models;
using Application.Applicants.Queries;
using Application.Jobs.Commands;
using Application.Jobs.Models;
using Application.Jobs.Queries;
using Application.Users.Models;
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


    //[HttpGet()]
    //[ProducesResponseType(typeof(Job), StatusCodes.Status200OK)]
    //[ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    //[ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    //public async Task<IActionResult> GetAllForUser()
    //{ 
    //    return Ok(await mediator.Send(new JobFindAllForEmployerQuery()));
    //}
    [HttpGet("{jobId}")]
    [ProducesResponseType(typeof(Job), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> FindJob([FromRoute] int jobId)
    {
        return Ok(await mediator.Send(new JobTryFindQuery(jobId)));
    }
    [HttpPut("{jobId}")]
    [ProducesResponseType(typeof(Job), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> Update([FromRoute] int jobId, [FromBody] JobSaveRequest request)
    {
         request.Id = jobId;
        var initialState = JobState.JobDetails;
        var initialStateInstance = state.CreateState(initialState);
        return Ok(await initialStateInstance.SaveDetails (request));
    } 
    [HttpPut("{jobId}/activate")]
    [ProducesResponseType(typeof(Job), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> ActivateJob([FromRoute] int jobId, [FromBody] int request)
    {
        return Ok(await mediator.Send(new JobActivateCommand(jobId, request)));
    }

    [HttpGet("search")]
    [ProducesResponseType(typeof(UserRegistrationResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status422UnprocessableEntity)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> SearchAsync(JobSearchRequest request)
    {
        return Ok(await mediator.Send(new JobSearchQuery(request)));
    }

    //JobGetApplicantsQuery
    [HttpGet("{jobId}/applicants")]
    [ProducesResponseType(typeof(IEnumerable<Applicant>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> FindJobApplicants([FromRoute] int jobId)
    {
        return Ok(await mediator.Send(new JobGetApplicantsQuery(jobId)));
    }
}