using Application.JobApplicationa.Commands;
using Application.JobApplications.Commands;
using Domain.Entities;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace WebAPI.Controllers;

[Route("api/jobs/{jobId}/applications")]
public class JobApplicationsController(IMediator mediator) : ControllerBase
{
    private readonly IMediator mediator = mediator;

    /// Apply to job
    /// </summary>
    /// <returns></returns>
    [HttpPost]
    [ProducesResponseType(typeof(JobApplication), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> ApplyToJob([FromRoute] int jobId)
    {
        return Ok(await mediator.Send(new JobApplicationApplyCommand(jobId)));
    }

    /// Delete job application
    /// </summary>
    /// <returns></returns>
    [HttpDelete]
    [ProducesResponseType(typeof(JobApplication), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> DeleteJobApplication([FromRoute] int jobId)
    {
        return Ok(await mediator.Send(new JobApplicationDeleteCommand(jobId)));
    }

    /// Accept job application
    /// </summary>
    /// <returns></returns>
    [HttpPatch("{jobApplicationId}/accept")]
    [ProducesResponseType(typeof(JobApplication), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> AcceptJobApplication([FromRoute] int jobId, [FromRoute] int jobApplicationId, [FromBody] bool accept)
    {
        return Ok(await mediator.Send(new JobApplicationAcceptCommand(jobId, jobApplicationId, accept)));
    }

}
