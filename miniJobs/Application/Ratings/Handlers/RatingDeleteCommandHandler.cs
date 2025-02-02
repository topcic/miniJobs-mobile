using Application.Ratings.Commands;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;
using System.Transactions;

namespace Application.Ratings.Handlers;
sealed class RatingDeleteCommandHandler(IRatingRepository ratingRepository) : IRequestHandler<RatingDeleteCommand, Rating>
{
    public async Task<Rating> Handle(RatingDeleteCommand command, CancellationToken cancellationToken)
    {
        using var ts = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);
        var rating = await ratingRepository.TryFindAsync(command.Id);

        await ratingRepository.DeleteAsync(rating);
        ts.Complete();
        return rating;
    }
}