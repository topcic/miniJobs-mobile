using Application.Common.Commands;
using Domain.Entities;

namespace Application.Ratings.Commands;

public class RatingInsertCommand : CommandBase<Rating>
{
    public Rating Request { get; set; }

    public RatingInsertCommand(Rating request)
    {
        Request = request;
    }
}