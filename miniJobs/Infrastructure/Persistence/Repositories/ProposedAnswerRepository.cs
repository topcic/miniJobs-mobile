namespace Infrastructure.Persistence.Repositories;

public class ProposedAnswerRepository(ApplicationDbContext context) : GenericRepository<ProposedAnswer, int, ApplicationDbContext>(context), IProposedAnswerRepository
{
}

