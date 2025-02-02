using Application.Common.Models;
using Application.Jobs.Commands;
using Application.Jobs.Models;
using Application.Jobs.Queries;
using Application.Users.Models;
using Domain.Entities;
using Domain.Interfaces;
using Infrastructure.Persistence.Repositories;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace WebAPI.Controllers;

[Route("api/jobs")]
[Authorize]
public class JobsController(IMediator mediator, IJobRepository
     jobRepository) : ControllerBase
{
    private readonly IMediator mediator = mediator;

    [HttpGet("public-search")]
    [Authorize(Roles = "Administrator")]
    [ProducesResponseType(typeof(SearchResponseBase<Job>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status422UnprocessableEntity)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> SearchAsync([FromQuery] Dictionary<string, string> parammeters)
    {
        var results = new SearchResponseBase<Job>();

        results.Result = await jobRepository.PublicFindPaginationAsync(parammeters);
        results.Count = await jobRepository.PublicCountAsync(parammeters);
        return Ok(results);
    }
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
    [Authorize]
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
    [Authorize(Roles = "Employer,Administrator")]
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


    [HttpDelete("{id}/admin")]
    [Authorize(Roles = "Administrator")]
    [ProducesResponseType(typeof(Job), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> DeleteByAdminAsync([FromRoute] int id)
    {
        return Ok(await mediator.Send(new JobDeleteByAdminCommand(id)));
    }

    [HttpPut("{id}/admin/activate")]
    [Authorize(Roles = "Administrator")]
    [ProducesResponseType(typeof(Job), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> ActivateByAdminAsync([FromRoute] int id)
    {
        return Ok(await mediator.Send(new JobActivateByAdminCommand(id)));
    }
}