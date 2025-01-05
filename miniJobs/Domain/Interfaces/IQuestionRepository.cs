using Domain.Entities;

namespace Domain.Interfaces;

public interface IQuestionRepository : IGenericRepository<Question, int>
{
    IEnumerable<ProposedAnswer> GetAnswersForQuestion(string questionName);
}