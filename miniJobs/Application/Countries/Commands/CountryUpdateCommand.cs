using Application.Common.Commands;
using Domain.Entities;

namespace Application.Countries.Commands;

public class CountryUpdateCommand(Country request) : CommandBase<Country>
{
    public Country Request { get; set; } = request;
}