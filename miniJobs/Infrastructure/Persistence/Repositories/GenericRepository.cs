using System.Linq.Expressions;

namespace Infrastructure.Persistence.Repositories;

public abstract class GenericRepository<TEntity, T, TContext> : IGenericRepository<TEntity, T>
    where TEntity : class, IEntity<T>, new()
    where T : IComparable, IEquatable<T>
    where TContext : DbContext
{
    private TContext _Context;
    protected readonly DbSet<TEntity> DbSet;

    protected TContext Context { get { return _Context; } }

    public GenericRepository(TContext context)
    {
        ArgumentNullException.ThrowIfNull(context);

        DbSet = context.Set<TEntity>();
        _Context = context;
    }

    public async Task<TEntity> TryFindAsync(T id)
    {
        return await DbSet.SingleOrDefaultAsync(x => x.Id.Equals(id));
    }

    public async Task<TEntity> FindOneAsync(Expression<Func<TEntity, bool>> condition)
    {
        return await DbSet.SingleOrDefaultAsync(condition);
    }

    public IEnumerable<TEntity> Find(Expression<Func<TEntity, bool>>? condition = null)
    {
        return  condition != null ? DbSet.Where(condition).AsEnumerable() : DbSet.AsEnumerable();
    }

    public async Task InsertAsync(TEntity entity)
    {
        await DbSet.AddAsync(entity);
        await Context.SaveChangesAsync();
    }

    public async Task UpdateAsync(TEntity entity)
    {
        DbSet.Update(entity);
        await Context.SaveChangesAsync();

    }

    public async Task DeleteAsync(TEntity entity)
    {
        DbSet.Remove(entity);
        await Context.SaveChangesAsync();
    }
}