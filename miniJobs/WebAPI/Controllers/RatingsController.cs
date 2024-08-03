using Application.Ratings.Commands;
using Domain.Entities;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace WebAPI.Controllers;

[Route("api/ratings")]
public class RatingsController(IMediator mediator) : ControllerBase
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

}