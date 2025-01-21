
using AutoMapper;
using Microsoft.EntityFrameworkCore;

namespace Infrastructure.Persistence.Repositories;

public class QuestionRepository(ApplicationDbContext context, IMapper mapper) : GenericRepository<Question, int, ApplicationDbContext>(context, mapper), IQuestionRepository
{
    public IEnumerable<ProposedAnswer> GetAnswersForQuestion(string questionName)
    {
        return context.ProposedAnswers
         .Join(
             context.Questions,
             answer => answer.QuestionId, 
             question => question.Id,
             (answer, question) => new { answer, question } 
         )
         .Where(joined => joined.question.Name == questionName) 
         .Select(joined => joined.answer) 
         .ToList();
    }
}