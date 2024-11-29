namespace Application.Common.Interfaces;

public interface IMessagePublisher<TMessage>
  where TMessage : class
{
    Task PublishAsync(TMessage message);
}
