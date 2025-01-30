using Domain.Dtos;
using Domain.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace WebAPI.Controllers;

[Route("api/statistics")]
[Authorize]

public class StatisticController(IStatisticRepository repository) : ControllerBase
{
    [HttpGet("overall")]
    [ProducesResponseType(typeof(OverallStatisticDto), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> GetOverallStatisticAsync()
    {
        return Ok(await repository.GetOverallStatisticsAsync());
    }
}
