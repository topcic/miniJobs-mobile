//using Domain.Interfaces;
//using Microsoft.EntityFrameworkCore;
//using System.Linq.Expressions;

//namespace Infrastructure.Persistence.Repositories;

//public class RepositoryBase<T>(ApplicationDbContext context) : IRepositoryBase<T> where T : class
//{
//    protected ApplicationDbContext context = context;

//    protected readonly DbSet<T> DbSet;


//    public async Task<T> TryFindAsync(int id)
//    {
//        //return await DbSet.SingleOrDefaultAsync(x => x.Id.Equals(id));
//    }

//    public async Task<T> FindOneAsync(Expression<Func<T, bool>> condition)
//    {
//        return await DbSet.SingleOrDefaultAsync(condition);
//    }

//    public IEnumerable<T> Find(Expression<Func<T, bool>>? condition = null)
//    {
//        return condition != null ? DbSet.Where(condition).AsEnumerable() : DbSet.AsEnumerable();
//    }
//    public IEnumerable<T> FindAll()
//    {
//        return DbSet.AsEnumerable();
//    }
//    public async Task InsertAsync(T entity)
//    {
//        await DbSet.AddAsync(entity);
//        await context.SaveChangesAsync();
//    }

//    public async Task UpdateAsync(T entity)
//    {
//        DbSet.Update(entity);
//        await context.SaveChangesAsync();

//    }

//    public async Task DeleteAsync(int id)
//    {
//        //  DbSet.SingleOrDefaultAsync(x => x.Id.Equals(id));
//        await context.SaveChangesAsync();
//    }
//}