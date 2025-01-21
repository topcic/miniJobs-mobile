using AutoMapper;

namespace Infrastructure.Persistence.Repositories;

public class MessageRepository(ApplicationDbContext context, IMapper mapper) : GenericRepository<Message, int, ApplicationDbContext>(context, mapper), IMessageRepository
{
}
