namespace Infrastructure.Common.Interfaces;
public interface IMessageProcessor<TMessage>
    where TMessage : class
{
    Task PublishAsync(TMessage message);
    Task ConsumeAsync(TMessage message);
}