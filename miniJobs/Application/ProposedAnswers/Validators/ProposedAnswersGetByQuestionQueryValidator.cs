using Application.Common.Extensions;
using Application.ProposedAnswers.Queries;
using Domain.Interfaces;
using FluentValidation;

namespace Application.ProposedAnswers.Validators;
public class ProposedAnswersGetByQuestionQueryValidator : AbstractValidator<ProposedAnswersGetByQuestionQuery>
{
    private readonly IQuestionRepository questionRepository;
    public ProposedAnswersGetByQuestionQueryValidator(IQuestionRepository questionRepository)
    {
        RuleFor(x => x).MustAsync(async (x, cancellation) => await Validate(x));
        this.questionRepository = questionRepository;
    }
    private async Task<bool> Validate(ProposedAnswersGetByQuestionQuery query)
    {
        var question = await questionRepository.FindOneAsync(x => x.Name == query.Question);
        ExceptionExtension.Validate("Pitanje ne postoji", () => question == null);
        return true;
    }
}