namespace Infrastructure.Persistence.Repositories;

public class MessageRepository(ApplicationDbContext context) : GenericRepository<Message, int, ApplicationDbContext>(context), IMessageRepository
{
}
