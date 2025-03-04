using Application.Common.Models;
using Application.JobTypes.Commands;
using Application.JobTypes.Queries;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace WebAPI.Controllers;


[Route("api/jobtypes")]
[Authorize]
public class JobTypesController(IMediator mediator, IJobTypeRepository jobTypeRepository) : ControllerBase
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
    [HttpGet("search")]
    [Authorize(Roles = "Administrator")]
    [ProducesResponseType(typeof(SearchResponseBase<JobType>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status422UnprocessableEntity)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> SearchAsync([FromQuery] Dictionary<string, string> parammeters)
    {
        var results = new SearchResponseBase<JobType>();

        results.Result = await jobTypeRepository.FindPaginationAsync(parammeters);
        results.Count = await jobTypeRepository.CountAsync(parammeters);
        return Ok(results);
    }

    [HttpDelete("{jobTypeId}")]
    [Authorize(Roles = "Administrator")]
    [ProducesResponseType(typeof(JobType), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> DeleteAsync([FromRoute] int jobTypeId)
    {
        return Ok(await mediator.Send(new JobTypeDeleteCommand(jobTypeId)));
    }
    [HttpPut("{jobTypeId}/activate")]
    [Authorize(Roles = "Administrator")]
    [ProducesResponseType(typeof(JobType), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> ActivateJob([FromRoute] int jobTypeId)
    {
        return Ok(await mediator.Send(new JobTypeActivateCommand(jobTypeId)));
    }

    [HttpPost("")]
    [Authorize(Roles = "Administrator")]
    [ProducesResponseType(typeof(JobType), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> PostAsync([FromBody] JobType request)
    {
        return Ok( await mediator.Send(new JobTypeInsertCommand(request)));
    }

    [HttpGet("{jobTypeId}")]
    [Authorize]
    [ProducesResponseType(typeof(Country), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> Get([FromRoute] int jobTypeId)
    {
        return Ok(await jobTypeRepository.TryFindAsync(jobTypeId));
    }
    [HttpPut("{jobTypeId}")]
    [Authorize(Roles = "Administrator")]
    [ProducesResponseType(typeof(Country), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> UpdateStep1([FromRoute] int jobTypeId, [FromBody] JobType request)
    {
        request.Id = jobTypeId;
        return Ok(await mediator.Send(new JobTypeUpdateCommand(request)));
    }

}