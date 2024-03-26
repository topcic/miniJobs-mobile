using Data.Entities;

namespace Infrastructure.Persistence.Repositories
{
    public class UserAuthCodeRepository(ApplicationDbContext context) : GenericRepository<UserAuthCode, int, ApplicationDbContext>(context), IUserAuthCodeRepository
    {
    }
}
