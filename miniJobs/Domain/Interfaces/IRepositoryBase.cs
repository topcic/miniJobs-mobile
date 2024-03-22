using System.Linq.Expressions;

namespace Domain.Interfaces;

public interface IRepositoryBase<T> where T : class
{
    /// <summary>
    /// Find all async
    /// </summary>
    /// <returns></returns>
    IEnumerable<T> FindAll();
    /// <summary>
    /// Try find by Id async
    /// </summary>
    /// <param name="id">Id</param>
    /// <returns></returns>
    Task<T> TryFindAsync(int id);
    /// <summary>
    /// Insert async
    /// </summary>
    /// <param name="item">Item</param>
    /// <returns></returns>
    Task InsertAsync(T item);
    /// <summary>
    /// Update async
    /// </summary>
    /// <param name="item">Item</param>
    /// <returns></returns>
    Task UpdateAsync(T item);
    /// <summary>
    /// Delete async
    /// </summary>
    /// <param name="id">Id</param>
    /// <returns></returns>
    Task DeleteAsync(int id);
    /// <summary>
    /// Find async by predicate
    /// </summary>
    /// <param name="predicate">Predicate expression</param>
    /// <returns></returns>
    IEnumerable<T> Find(Expression<Func<T, bool>> predicate);
    /// <summary>
    /// Find one async by predicate
    /// </summary>
    /// <param name="predicate">Predicate expression</param>
    /// <returns></returns>
    Task<T> FindOneAsync(Expression<Func<T, bool>> predicate); 
}