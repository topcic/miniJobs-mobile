using System.Linq.Expressions;
namespace Domain.Interfaces;

public interface IRepositoryBase<T> where T : IEntity<int>
{
    /// <summary>
    /// Find all async
    /// </summary>
    /// <returns></returns>
    Task<IEnumerable<T>> FindAllAsync();
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

    Task<int> CountAsync(Dictionary<string, string> parameters = null);

    Task<IEnumerable<T>> FindPaginationAsync(Dictionary<string, string> parameters = null);
}