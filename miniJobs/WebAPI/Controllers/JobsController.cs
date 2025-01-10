using Application.Jobs.Commands;
using Application.Jobs.Models;
using Application.Jobs.Queries;
using Application.Users.Models;
using Domain.Entities;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace WebAPI.Controllers;

[Route("api/jobs")]
[Authorize]
public class JobsController(IMediator mediator) : ControllerBase
{
    private readonly IMediator mediator = mediator;

    [HttpPost("")]
    [Authorize(Roles = "Employer")]
    [ProducesResponseType(typeof(Job), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> PostAsync([FromBody] JobStep1Request request)
    {
        return Ok(await mediator.Send(new JobInsertCommand(request)));
    }

    [HttpGet("{jobId}")]
    [Authorize(Roles = "Applicant,Employer")]
    [ProducesResponseType(typeof(Job), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> FindJob([FromRoute] int jobId)
    {
        return Ok(await mediator.Send(new JobTryFindQuery(jobId)));
    }
    [HttpPut("{jobId}/step1")]
    [Authorize(Roles = "Employer")]
    [ProducesResponseType(typeof(Job), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> UpdateStep1([FromRoute] int jobId, [FromBody] JobStep1Request request)
    {
        request.Id = jobId;
        return Ok(await mediator.Send(new JobStep1UpdateCommand(request)));
    }

    [HttpPut("{jobId}/step2")]
    [Authorize(Roles = "Employer")]
    [ProducesResponseType(typeof(Job), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> UpdateStep2([FromRoute] int jobId, [FromBody] JobStep2Request request)
    {
        request.Id = jobId;
        return Ok(await mediator.Send(new JobStep2UpdateCommand(request)));
    }

    [HttpPut("{jobId}/step3")]
    [Authorize(Roles = "Employer")]
    [ProducesResponseType(typeof(Job), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> UpdateStep3([FromRoute] int jobId, [FromBody] JobStep3Request request)
    {
        request.Id = jobId;
        return Ok(await mediator.Send(new JobStep3UpdateCommand(request)));
    }
    [HttpPut("{jobId}/activate")]
    [Authorize(Roles = "Employer")]
    [ProducesResponseType(typeof(Job), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> ActivateJob([FromRoute] int jobId, [FromBody] int request)
    {
        return Ok(await mediator.Send(new JobActivateCommand(jobId, request)));
    } 

    [HttpPut("{jobId}/finish")]
    [Authorize(Roles = "Employer")]
    [ProducesResponseType(typeof(Job), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> FinishJob([FromRoute] int jobId)
    {
        return Ok(await mediator.Send(new JobFinishCommand(jobId)));
    }

    [HttpGet("search")]
    [Authorize(Roles = "Applicant")]
    [ProducesResponseType(typeof(UserRegistrationResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status422UnprocessableEntity)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> SearchAsync(JobSearchRequest request)
    {
        return Ok(await mediator.Send(new JobSearchQuery(request)));
    }


    [HttpGet("{jobId}/applicants")]
    [Authorize(Roles = "Employer")]
    [ProducesResponseType(typeof(IEnumerable<Applicant>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> FindJobApplicants([FromRoute] int jobId)
    {
        return Ok(await mediator.Send(new JobGetApplicantsQuery(jobId)));
    }

    [HttpDelete("{id}")]
    [Authorize(Roles = "Employer")]
    [ProducesResponseType(typeof(Job), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> DeleteAsync([FromRoute] int id)
    {
        return Ok(await mediator.Send(new JobDeleteCommand(id)));
    }
}