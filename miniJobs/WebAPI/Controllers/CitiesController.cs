using Application.Cities.Queries;
using Domain.Entities;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace WebAPI.Controllers;

[Route("api/cities")]
public class CitiesController(IMediator mediator) : ControllerBase
{
    private readonly IMediator mediator = mediator;

    [AllowAnonymous]
    [HttpGet("")]
    [ProducesResponseType(typeof(IEnumerable<City>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> FindAllAsync()
    {
        return Ok(await mediator.Send(new CityFindAllQuery()));
    }

}