namespace Infrastructure.Persistence.Repositories;

public class UserManagerRepository(ApplicationDbContext context) : GenericRepository<User, int, ApplicationDbContext>(context), IUserManagerRepository
{
    private ApplicationDbContext context = context;
    protected readonly DbSet<User> dbSet = context.Set<User>();
    public async Task<User> TryFindByEmailAsync(string email)
    {
        return await dbSet.SingleOrDefaultAsync(x => x.Email == email);
    }

    public async Task<IEnumerable<UserRole>> GetAllRolesAsync(int userId)
    {
        return dbSet.Where(x => x.Id== userId)
            .Join(context.Set<UserRole>(),
             u => u.Id,
             ur => ur.UserId,
             (u, ur) => ur).AsEnumerable();
    }

    public async Task<Role> TryFindRoleAsync(string roleId)
    {
        return await context.Set<Role>().FirstOrDefaultAsync(x => x.Id == roleId);
    }
}
