using Domain.Interfaces;
using Microsoft.EntityFrameworkCore;
using System.Linq.Expressions;

namespace Infrastructure.Persistence.Repositories;

public class RepositoryBase<T>(ApplicationDbContext context) : IRepositoryBase<T> where T : class, IEntity<int>
{
    protected ApplicationDbContext _context = context;
    
    protected readonly DbSet<T> _dbSet;



    public async Task<IEnumerable<T>> FindAllAsync()
    {
        return await _dbSet.ToListAsync();
    }

    public async Task<T> TryFindAsync(int id)
    {
        var entity = await _dbSet.FindAsync(id);
        return entity;
    }

    public async Task InsertAsync(T entity)
    {
        await _dbSet.AddAsync(entity);
        await _context.SaveChangesAsync();
    }

    public async Task UpdateAsync(T entity)
    {
        _dbSet.Update(entity);
        await _context.SaveChangesAsync();
    }

    public async Task DeleteAsync(int id)
    {
        var entity = await TryFindAsync(id); 
        _dbSet.Remove(entity);
        await _context.SaveChangesAsync();
    }

    public IEnumerable<T> Find(Expression<Func<T, bool>> predicate)
    {
        return _dbSet.Where(predicate).AsEnumerable();
    }

    public async Task<T> FindOneAsync(Expression<Func<T, bool>> predicate)
    {
        return await _dbSet.SingleOrDefaultAsync(predicate);
    }
}