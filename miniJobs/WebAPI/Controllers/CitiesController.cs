using Application.Cities.Commands;
using Application.Cities.Queries;
using Application.Common.Models;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace WebAPI.Controllers;

[Route("api/cities")]
public class CitiesController(IMediator mediator,ICityRepository cityRepository) : ControllerBase
{
    [HttpGet("search")]
    [Authorize(Roles = "Administrator")]
    [ProducesResponseType(typeof(SearchResponseBase<City>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status422UnprocessableEntity)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> SearchAsync([FromQuery] Dictionary<string, string> parammeters)
    {
        var results = new SearchResponseBase<City>();

        results.Result = await cityRepository.FindPaginationAsync(parammeters);
        results.Count = await cityRepository.CountAsync(parammeters);
        return Ok(results);
    }

    [AllowAnonymous]
    [HttpGet("")]
    [ProducesResponseType(typeof(IEnumerable<City>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> FindAllAsync()
    {
        return Ok(await mediator.Send(new CityFindAllQuery()));
    }

    [HttpDelete("{cityId}")]
    [Authorize(Roles = "Administrator")]
    [ProducesResponseType(typeof(City), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> DeleteAsync([FromRoute] int cityId)
    {
        return Ok(await mediator.Send(new CityDeleteCommand(cityId)));
    }
    [HttpPut("{cityId}/activate")]
    [Authorize(Roles = "Administrator")]
    [ProducesResponseType(typeof(City), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> Activate([FromRoute] int cityId)
    {
        return Ok(await mediator.Send(new CityActivateCommand(cityId)));
    }

    [HttpPost("")]
    [Authorize(Roles = "Administrator")]
    [ProducesResponseType(typeof(City), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> PostAsync([FromBody] City request)
    {
        return Ok(await mediator.Send(new CityInsertCommand(request)));
    }

    [HttpGet("{cityId}")]
    [Authorize]
    [ProducesResponseType(typeof(Job), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> Get([FromRoute] int cityId)
    {
        return Ok(await cityRepository.TryFindAsync(cityId));
    }
    [HttpPut("{cityId}")]
    [Authorize(Roles = "Administrator")]
    [ProducesResponseType(typeof(City), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> Update([FromRoute] int cityId, [FromBody] City request)
    {
        request.Id = cityId;
        return Ok(await mediator.Send(new CityUpdateCommand(request)));
    }
}