using Application.Common.Queries;
using Domain.Entities;

namespace Application.ProposedAnswers.Queries;

public class ProposedAnswersGetByQuestionQuery(string question) : QueryBase<IEnumerable<ProposedAnswer>>
{
    public string Question { get; set; } = question;
}
