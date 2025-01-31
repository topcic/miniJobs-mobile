using Domain.Entities;
using Domain.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace WebAPI.Controllers;

[Route("api/reports")]
[Authorize]

public class ReportsController(IJobRepository jobRepository) : ControllerBase
{
    [HttpGet("jobs")]
    [ProducesResponseType(typeof(IEnumerable<Job>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> GetOverallStatisticAsync()
    {
        return Ok(await jobRepository.GetJobsForReportsAsync());
    }
}