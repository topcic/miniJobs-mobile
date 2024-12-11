using Application.JobRecommendations.Commands;
using Application.JobRecommendations.Models;
using Application.JobRecommendations.Queries;
using Domain.Entities;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace WebAPI.Controllers;

[Route("api/job-recommendations")]
public class JobRecommendationsController(IMediator mediator) : ControllerBase
{
    private readonly IMediator mediator = mediator;

    [HttpPost("")]
    [ProducesResponseType(typeof(JobRecommendation), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> PostAsync([FromBody] JobRecommendationRequest request)
    {
        return Ok(await mediator.Send(new JobRecommendationInsertCommand(request)));
    }


    [HttpPut("{jobRecommendationId}")]
    [ProducesResponseType(typeof(JobRecommendation), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> Update([FromRoute] int jobRecommendationId, [FromBody] JobRecommendationRequest request)
    {
        return Ok(await mediator.Send(new JobRecommendationUpdateCommand(jobRecommendationId, request)));
    }
    [HttpDelete("{id}")]
    [ProducesResponseType(typeof(JobRecommendation), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> DeleteAsync([FromRoute] int id)
    {
        return Ok(await mediator.Send(new JobRecommendationDeleteCommand(id)));
    }
}