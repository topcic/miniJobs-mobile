using AutoMapper;

namespace Infrastructure.Persistence.Repositories;

public class ProposedAnswerRepository(ApplicationDbContext context, IMapper mapper) : GenericRepository<ProposedAnswer, int, ApplicationDbContext>(context, mapper), IProposedAnswerRepository
{
}

