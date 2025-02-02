using Application.Common.Commands;
using Domain.Entities;

namespace Application.Ratings.Commands;

public class RatingDeleteCommand(int id) : CommandBase<Rating>
{
    public int Id { get; set; } = id;
}
