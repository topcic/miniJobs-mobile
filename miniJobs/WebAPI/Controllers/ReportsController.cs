using Domain.Entities;
using Domain.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace WebAPI.Controllers;

[Route("api/reports")]
[Authorize]

public class ReportsController(IJobRepository jobRepository, IJobApplicationRepository jobApplicationRepository, IRatingRepository ratingRepository) : ControllerBase
{
    [HttpGet("jobs")]
    [Authorize(Roles = "Administrator")]
    [ProducesResponseType(typeof(IEnumerable<Job>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> GetJobsAsync()
    {
        return Ok(await jobRepository.GetJobsForReportsAsync());
    }

    [HttpGet("job-applications")]
    [Authorize(Roles = "Administrator")]
    [ProducesResponseType(typeof(IEnumerable<JobApplication>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> GetJobApplicationsAsync()
    {
        return Ok(await jobApplicationRepository.GetJobApplicationForReportsAsync());
    }

    [HttpGet("ratings")]
    [Authorize(Roles = "Administrator")]
    [ProducesResponseType(typeof(IEnumerable<Rating>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> GetRatingsAsync()
    {
        return Ok(await ratingRepository.GetRatingsForReportsAsync());
    }
}