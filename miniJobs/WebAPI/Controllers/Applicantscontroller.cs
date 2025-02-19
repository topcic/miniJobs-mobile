using Application.Applicants.Commands;
using Application.Applicants.Models;
using Application.Applicants.Queries;
using Application.Common.Models;
using Application.Jobs.Commands;
using Domain.Dtos;
using Domain.Entities;
using Domain.Interfaces;
using Infrastructure.Persistence.Repositories;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace WebAPI.Controllers;

[Route("api/applicants")]
[Authorize]
public class Applicantscontroller(IMediator mediator,IApplicantRepository applicantRepository) : ControllerBase
{
    private readonly IMediator mediator = mediator;
    [HttpGet("public-search")]
    [Authorize(Roles = "Administrator")]
    [ProducesResponseType(typeof(SearchResponseBase<ApplicantDTO>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status422UnprocessableEntity)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> SearchAsync([FromQuery] Dictionary<string,string> parammeters)
    {
        var results = new SearchResponseBase<ApplicantDTO>();

        results.Result = await applicantRepository.PublicFindPaginationAsync(parammeters);
        results.Count = await applicantRepository.PublicCountAsync(parammeters);
        return Ok(results);
    }
    [HttpGet("search")]
    [Authorize(Roles = "Employer")]
    [ProducesResponseType(typeof(SearchResponseBase<Job>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status422UnprocessableEntity)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> SearchAsync(ApplicantSearchRequest request)
    {
        return Ok(await mediator.Send(new ApplicantSearchAsyncQuery(request)));
    }

    [HttpGet("applied-jobs")]
    [Authorize(Roles = "Applicant")]
    [ProducesResponseType(typeof(IEnumerable<JobApplication>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status422UnprocessableEntity)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> GetAppliedJobs()
    {
        return Ok(await mediator.Send(new ApplicantGetAppliedJobsQuery()));
    }

    [HttpGet("saved-jobs")]
    [Authorize(Roles = "Applicant")]
    [ProducesResponseType(typeof(IEnumerable<JobCardDTO>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status422UnprocessableEntity)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> GetSavedJobs()
    {
        return Ok(await mediator.Send(new ApplicantGetSavedJobsQuery()));
    }

    [HttpGet("{applicantId}")]
    [ProducesResponseType(typeof(ApplicantDTO), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> FindUser([FromRoute] int applicantId)
    {
        return Ok(await mediator.Send(new ApplicantTryFindQuery(applicantId)));
    }

    [HttpPut("{applicantId}")]
    [Authorize(Roles = "Applicant")]
    [ProducesResponseType(typeof(Applicant), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status422UnprocessableEntity)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> UpdateAsync([FromRoute] int applicantId, [FromForm] ApplicantUpdateRequest request)
    {
        return Ok(await mediator.Send(new ApplicantUpdateCommand(applicantId, request)));
    }
    [HttpPost("saved-jobs/{jobId}")]
    [Authorize(Roles = "Applicant")]
    [ProducesResponseType(typeof(Job), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status422UnprocessableEntity)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> SaveJobAsync([FromRoute] int jobId)
    {
        return Ok(await mediator.Send(new JobSaveCommand(jobId)));
    }

    [HttpDelete("saved-jobs/{jobId}")]
    [Authorize(Roles = "Applicant")]
    [ProducesResponseType(typeof(Job), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status422UnprocessableEntity)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> UnsaveJobAsync([FromRoute] int jobId)
    {
        return Ok(await mediator.Send(new JobUnsaveCommand(jobId)));
    }
}