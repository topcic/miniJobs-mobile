using Application.Recommendations.Queries;
using Domain.Entities;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace WebAPI.Controllers;
[Route("api/recommendations")]
[Authorize]
public class RecommendationsController(IMediator mediator) : ControllerBase
{

    [HttpGet("jobs")]
    [Authorize(Roles = "Applicant")]
    [ProducesResponseType(typeof(IEnumerable<Job>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> GetJobs()
    {
        return Ok(await mediator.Send(new RecommendationJobsQuery()));
    }
}