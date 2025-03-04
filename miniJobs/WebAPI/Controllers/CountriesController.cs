using Application.Common.Models;
using Application.Countries.Commands;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace WebAPI.Controllers;
[Route("api/countries")]
public class CountriesController(IMediator mediator, ICountryRepository repository) : ControllerBase
{

    [AllowAnonymous]
    [HttpGet("")]
    [Authorize(Roles = "Administrator")]
    [ProducesResponseType(typeof(IEnumerable<Country>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> FindAllAsync()
    {
        return Ok(await repository.FindAllAsync());
    }

    [HttpDelete("{countryId}")]
    [Authorize(Roles = "Administrator")]
    [ProducesResponseType(typeof(Country), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> DeleteAsync([FromRoute] int countryId)
    {
        return Ok(await mediator.Send(new CountryDeleteCommand(countryId)));
    }
    [HttpPut("{countryId}/activate")]
    [Authorize(Roles = "Administrator")]
    [ProducesResponseType(typeof(Country), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> ActivateJob([FromRoute] int countryId)
    {
        return Ok(await mediator.Send(new CountryActivateCommand(countryId)));
    }

    [HttpPost("")]
    [Authorize(Roles = "Administrator")]
    [ProducesResponseType(typeof(Country), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> PostAsync([FromBody] Country request)
    {
        return Ok(await mediator.Send(new CountryInsertCommand(request)));
    }

    [HttpGet("{countryId}")]
    [Authorize]
    [ProducesResponseType(typeof(Country), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> Get([FromRoute] int countryId)
    {
        return Ok(await repository.TryFindAsync(countryId));
    }
    [HttpPut("{countryId}")]
    [Authorize(Roles = "Administrator")]
    [ProducesResponseType(typeof(Country), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> UpdateStep1([FromRoute] int countryId, [FromBody] Country request)
    {
        request.Id = countryId;
        return Ok(await mediator.Send(new CountryUpdateCommand(request)));
    }

    [HttpGet("search")]
    [Authorize(Roles = "Administrator")]
    [ProducesResponseType(typeof(SearchResponseBase<Country>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status422UnprocessableEntity)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> SearchAsync([FromQuery] Dictionary<string, string> parammeters)
    {
        var results = new SearchResponseBase<Country>();

        results.Result = await repository.FindPaginationAsync(parammeters);
        results.Count = await repository.CountAsync(parammeters);
        return Ok(results);
    }
}