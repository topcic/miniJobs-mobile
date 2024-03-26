using System.Linq.Expressions;

namespace Infrastructure.Persistence.Repositories;
public class TokenRepository(ApplicationDbContext context) : GenericRepository<RefreshToken, string, ApplicationDbContext>(context), ITokenRepository
{
    private ApplicationDbContext context = context;
    protected readonly DbSet<RefreshToken> dbSet = context.Set<RefreshToken>();


    public async Task DeleteAllByUserAsync(int userId)
    {
        var tokensToDelete = dbSet.Where(token => token.UserId == userId);
        dbSet.RemoveRange(tokensToDelete);
        await context.SaveChangesAsync();
    }

}