﻿using Application.Common.Commands;
using Domain.Entities;

namespace Application.Countries.Commands;

public class CountryDeleteCommand(int id) : CommandBase<Country>
{
    public int Id { get; set; } = id;
}