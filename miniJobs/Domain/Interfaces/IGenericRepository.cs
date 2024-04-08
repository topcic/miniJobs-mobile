using System.Linq.Expressions;

namespace Domain.Interfaces;

public interface IGenericRepository<TEntity, T>
    where TEntity : class, IEntity<T>, new()
    where T : IComparable, IEquatable<T>
{
    Task<IEnumerable<TEntity>> FindAllAsync();
    Task<TEntity> TryFindAsync(T id);
    Task<TEntity> FindOneAsync(Expression<Func<TEntity, bool>> condition);
    IEnumerable<TEntity> Find(Expression<Func<TEntity, bool>>? condition = null);
    Task InsertAsync(TEntity entity);
    Task UpdateAsync(TEntity entity);
    Task DeleteAsync(TEntity entity);
}