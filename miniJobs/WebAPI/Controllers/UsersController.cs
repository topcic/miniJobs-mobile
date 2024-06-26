﻿using Application.Jobs.Models;
using Application.Users.Commands;
using Application.Users.Models;
using Domain.Entities;
using Domain.Enums;
using Infrastructure.JobStateMachine;
using MediatR;
using Microsoft.AspNetCore.Mvc;

namespace WebAPI.Controllers;
[Route("api/users")]
public class UsersController(IMediator mediator, BaseState state) : ControllerBase
{
    private readonly IMediator mediator = mediator;
    private readonly BaseState state = state;


    [HttpGet("")]
    [ProducesResponseType(typeof(IEnumerable<User>), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> GetAll()
    {

        var users = CreateDummyUsers(); // Call method to create dummy users
        return Ok(users);
    }

    [HttpPost("")]
    [ProducesResponseType(typeof(User), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(string), StatusCodes.Status400BadRequest)]
    [ProducesResponseType(typeof(string), StatusCodes.Status422UnprocessableEntity)]
    [ProducesResponseType(typeof(string), StatusCodes.Status500InternalServerError)]
    public async Task<IActionResult> PostAsync([FromBody] UserSaveRequest request)
    {
        return Ok(await mediator.Send(new UserInsertCommand(request)));
    }
    private SearchResult CreateDummyUsers()
    {
        var users = new List<User>();
        var r = new SearchResult();
        // Create 5 dummy users
        for (int i = 1; i <= 5; i++)
        {
            users.Add(new User
            {
                Id = i,
                FirstName = $"User{i}",
                LastName = $"LastName{i}",
                Role = $"username{i}",
                Email = $"user{i}@example.com",
                PhoneNumber = $"123456{i}",
                Gender = Gender.Male, // or Gender.Female or Gender.Other
                DateOfBirth = DateTime.Now.AddYears(-i),
                Deleted = i % 2 == 0,
                AccountConfirmed = i % 2 != 0
            }) ;
        }

        r.Count = 5;
        r.Result= users;
        return r;
    }
}
public class SearchResult
{
    public int Count { get; set; }
    public List<User> Result { get; set; }
}