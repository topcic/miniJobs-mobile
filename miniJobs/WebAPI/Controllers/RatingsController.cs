using Application.Common.Models;
using Application.Jobs.Commands;
using Application.Ratings.Commands;
using Domain.Entities;
using Domain.Interfaces;
using Infrastructure.Persistence.Repositories;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace WebAPI.Controllers;

[Route("api/ratings")]
[Authorize]
public class RatingsController(IMediator mediator,IRatingRepository ratingRepository) : ControllerBase
{
    private readonly IMediator mediator = mediator;


    [HttpPost("")]
    [ProducesResponseType(typeof(Rating), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status422UnprocessableEntity)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> PostAsync([FromBody] Rating request)
    {
        return Ok(await mediator.Send(new RatingInsertCommand(request)));
    }
    [HttpGet("search")]
    [Authorize(Roles = "Administrator")]
    [ProducesResponseType(typeof(SearchResponseBase<Rating>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status422UnprocessableEntity)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> SearchAsync([FromQuery] Dictionary<string, string> parammeters)
    {
        var results = new SearchResponseBase<Rating>();

        results.Result = await ratingRepository.FindPaginationAsync(parammeters);
        results.Count = await ratingRepository.CountAsync(parammeters);
        return Ok(results);
    }

    [HttpDelete("{id}")]
    [Authorize(Roles = "Administrator")]
    [ProducesResponseType(typeof(Rating), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> DeleteAsync([FromRoute] int id)
    {
        return Ok(await mediator.Send(new RatingDeleteCommand(id)));
    }
}