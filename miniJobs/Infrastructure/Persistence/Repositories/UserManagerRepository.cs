using Domain.Entities;
using Microsoft.EntityFrameworkCore;

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

    public async Task<UserRole> AssignUserRoleAsync(User user, Role role)
    {
        var userRole = new UserRole()
        {
            UserId = user.Id,
            RoleId = role.Id,
        };
        await context.Set<UserRole>().AddAsync(userRole);
        await context.SaveChangesAsync();
        return userRole;
    }

    public async Task<IEnumerable<Rating>> GetRatings(int userId)
    {
        var ratings = await context.Ratings
                                   .Where(r => r.RatedUserId == userId)
                                   .ToListAsync();
        return ratings;
    }
}
