using Application.ProposedAnswers.Queries;
using Domain.Entities;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace WebAPI.Controllers;


[Route("api/proposedanswers")]
public class ProposedAnswersController(IMediator mediator) : ControllerBase
{
    private readonly IMediator mediator = mediator;


    [HttpGet("")]
    [ProducesResponseType(typeof(IEnumerable<ProposedAnswer>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> FindByQuestionAsync([FromQuery] string question)
    {
        return Ok(await mediator.Send(new ProposedAnswersGetByQuestionQuery(question)));
    }

}