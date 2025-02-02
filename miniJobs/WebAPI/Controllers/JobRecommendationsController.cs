using Application.Common.Models;
using Application.JobRecommendations.Commands;
using Application.JobRecommendations.Models;
using Domain.Dtos;
using Domain.Entities;
using Domain.Interfaces;
using Infrastructure.Persistence.Repositories;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace WebAPI.Controllers;

[Route("api/job-recommendations")]
[Authorize]
public class JobRecommendationsController(IMediator mediator,IJobRecommendationRepository jobRecommendationRepository) : ControllerBase
{
    private readonly IMediator mediator = mediator;

    [HttpPost("")]
    [Authorize(Roles = "Applicant")]
    [ProducesResponseType(typeof(JobRecommendation), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> PostAsync([FromBody] JobRecommendationRequest request)
    {
        return Ok(await mediator.Send(new JobRecommendationInsertCommand(request)));
    }


    [HttpPut("{jobRecommendationId}")]
    [Authorize(Roles = "Applicant")]
    [ProducesResponseType(typeof(JobRecommendation), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> Update([FromRoute] int jobRecommendationId, [FromBody] JobRecommendationRequest request)
    {
        return Ok(await mediator.Send(new JobRecommendationUpdateCommand(jobRecommendationId, request)));
    }
    [HttpDelete("{id}")]
    [Authorize(Roles = "Applicant")]
    [ProducesResponseType(typeof(JobRecommendation), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> DeleteAsync([FromRoute] int id)
    {
        return Ok(await mediator.Send(new JobRecommendationDeleteCommand(id)));
    }

    [HttpGet("search")]
    [Authorize(Roles = "Administrator")]
    [ProducesResponseType(typeof(SearchResponseBase<JobRecommendationDTO>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status422UnprocessableEntity)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> SearchAsync([FromQuery] Dictionary<string, string> parammeters)
    {
        var results = new SearchResponseBase<JobRecommendationDTO>();

        results.Result = await jobRecommendationRepository.PublicFindPaginationAsync(parammeters);
        results.Count = await jobRecommendationRepository.PublicCountAsync(parammeters);
        return Ok(results);
    }
}