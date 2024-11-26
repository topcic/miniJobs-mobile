namespace Application.Common.Interfaces;

public interface IUnitOfWork
{
    Task ExecuteAsync(Func<Task> operation, CancellationToken cancellationToken = default);
    Task<T> ExecuteAsync<T>(Func<Task<T>> operation, CancellationToken cancellationToken = default);
}