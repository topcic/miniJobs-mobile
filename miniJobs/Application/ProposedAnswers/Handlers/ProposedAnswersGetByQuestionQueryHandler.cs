using Application.ProposedAnswers.Queries;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.ProposedAnswers.Handlers;

sealed class ProposedAnswersGetByQuestionQueryHandler(IQuestionRepository questionRepository,
   IProposedAnswerRepository proposedAnswerRepository) : IRequestHandler<ProposedAnswersGetByQuestionQuery, IEnumerable<ProposedAnswer>>
{
    public async Task<IEnumerable<ProposedAnswer>> Handle(ProposedAnswersGetByQuestionQuery request, CancellationToken cancellationToken)
    {
        var question = await questionRepository.FindOneAsync(x => x.Name == request.Question);
        return proposedAnswerRepository.Find(x => x.QuestionId == question.Id);
    }
}
