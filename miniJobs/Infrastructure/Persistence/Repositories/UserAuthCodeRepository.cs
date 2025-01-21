using AutoMapper;
using Data.Entities;

namespace Infrastructure.Persistence.Repositories
{
    public class UserAuthCodeRepository(ApplicationDbContext context, IMapper mapper) : GenericRepository<UserAuthCode, int, ApplicationDbContext>(context, mapper), IUserAuthCodeRepository
    {
    }
}
