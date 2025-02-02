using Application.Common.Models;
using Domain.Entities;
using Domain.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace WebAPI.Controllers; 


[Route("api/saved-jobs")]
[Authorize]
public class SavedJobsController(ISavedJobRepository savedJobRepository) : ControllerBase
{


    [HttpGet("search")]
    [Authorize(Roles = "Administrator")]
    [ProducesResponseType(typeof(SearchResponseBase<SavedJob>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status422UnprocessableEntity)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> SearchAsync([FromQuery] Dictionary<string, string> parammeters)
    {
        var results = new SearchResponseBase<SavedJob>();

        results.Result = await savedJobRepository.FindPaginationAsync(parammeters);
        results.Count = await savedJobRepository.CountAsync(parammeters);
        return Ok(results);
    }
}