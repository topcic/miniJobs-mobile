namespace Infrastructure.Persistence.Repositories;

public class UserRepository(ApplicationDbContext context) : GenericRepository<User, int, ApplicationDbContext>(context), IUserRepository
{
}
