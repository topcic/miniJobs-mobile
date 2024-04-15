using Application.Common.Extensions;
using Application.ProposedAnswers.Queries;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.ProposedAnswers.Handlers;

sealed class ProposedAnswersGetByQuestionQueryHandler(IQuestionRepository questionRepository,
   IProposedAnswerRepository proposedAnswerRepository) : IRequestHandler<ProposedAnswersGetByQuestionQuery, IEnumerable<ProposedAnswer>>
{
    private readonly IQuestionRepository questionRepository = questionRepository;
    private readonly IProposedAnswerRepository proposedAnswerRepository = proposedAnswerRepository;

    public async Task<IEnumerable<ProposedAnswer>> Handle(ProposedAnswersGetByQuestionQuery request, CancellationToken cancellationToken)
    {
       var question= await questionRepository.FindOneAsync(x=>x.Name==request.Question);
        ExceptionExtension.Validate("Pitanje ne postoji", () => question == null);

        return proposedAnswerRepository.Find(x => x.QuestionId == question.Id);
    }
}
