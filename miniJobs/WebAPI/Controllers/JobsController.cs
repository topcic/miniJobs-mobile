using Application.Jobs.Commands;
using Application.Jobs.Models;
using Application.Jobs.Queries;
using Application.Users.Models;
using Domain.Entities;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace WebAPI.Controllers;

[Route("api/jobs")]
public class JobsController(IMediator mediator) : ControllerBase
{
    private readonly IMediator mediator = mediator;

    [HttpPost("")]
    [ProducesResponseType(typeof(Job), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> PostAsync([FromBody] JobInsertRequest request)
    {
        return Ok(await mediator.Send(new JobInsertCommand(request)));
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
        return Ok(await mediator.Send(new JobUpdateCommand(request)));
    }
    [HttpPut("{jobId}/activate")]
    [ProducesResponseType(typeof(Job), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> ActivateJob([FromRoute] int jobId, [FromBody] int request)
    {
        return Ok(await mediator.Send(new JobActivateCommand(jobId, request)));
    } 

    [HttpPut("{jobId}/finish")]
    [ProducesResponseType(typeof(Job), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> FinishJob([FromRoute] int jobId)
    {
        return Ok(await mediator.Send(new JobFinishCommand(jobId)));
    }

    [HttpGet("search")]
    [ProducesResponseType(typeof(UserRegistrationResponse), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status422UnprocessableEntity)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> SearchAsync(JobSearchRequest request)
    {
        return Ok(await mediator.Send(new JobSearchQuery(request)));
    }


    [HttpGet("{jobId}/applicants")]
    [ProducesResponseType(typeof(IEnumerable<Applicant>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> FindJobApplicants([FromRoute] int jobId)
    {
        return Ok(await mediator.Send(new JobGetApplicantsQuery(jobId)));
    }

    [HttpDelete("{id}")]
    [ProducesResponseType(typeof(Job), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> DeleteAsync([FromRoute] int id)
    {
        return Ok(await mediator.Send(new JobDeleteCommand(id)));
    }
}