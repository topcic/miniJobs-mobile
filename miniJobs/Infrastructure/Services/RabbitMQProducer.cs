using Application.Common;
using Newtonsoft.Json;
using RabbitMQ.Client;
using System.Text;

namespace Infrastructure.Services;

public class RabbitMQProducer : IRabbitMQProducer
{
    private readonly string _exchangeName = "EmailExchange";
    private readonly string _routingKey = "email_queue";
    private readonly string _queueName = "EmailQueue";

    public void SendMessage<T>(T message)
    {
        var factory = new ConnectionFactory
        {
            HostName = Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? "rabbitmq",
            Port = int.Parse(Environment.GetEnvironmentVariable("RABBITMQ_PORT") ?? "5672"),
            UserName = Environment.GetEnvironmentVariable("RABBITMQ_USERNAME") ?? "guest",
            Password = Environment.GetEnvironmentVariable("RABBITMQ_PASSWORD") ?? "guest",
            ClientProvidedName = "Rabbit Test Producer"
        };

        using var connection = factory.CreateConnection();
        using var channel = connection.CreateModel();

        channel.ExchangeDeclare(_exchangeName, ExchangeType.Direct, durable: true);
        channel.QueueDeclare(_queueName, durable: true, exclusive: false, autoDelete: false);
        channel.QueueBind(_queueName, _exchangeName, _routingKey);

        var json = JsonConvert.SerializeObject(message);
        var body = Encoding.UTF8.GetBytes(json);

        channel.BasicPublish(_exchangeName, _routingKey, body: body);
    }
}
