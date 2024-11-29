using Application.Common.Interfaces;
using MassTransit;

namespace Infrastructure.Services;

public class MessagePublisher<TMessage>(IPublishEndpoint publishEndpoint) : IMessagePublisher<TMessage>
 where TMessage : class
{
    public async Task PublishAsync(TMessage message)
    {
        await publishEndpoint.Publish(message);
    }
}