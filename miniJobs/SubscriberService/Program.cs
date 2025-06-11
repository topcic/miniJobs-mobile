using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using System.Text;
using SubscribeService;

class Program
{
    private const string ExchangeName = "EmailExchange";
    private const string QueueName = "EmailQueue";
    private const string RoutingKey = "email_queue";

    static async Task Main(string[] args)
    {
        Console.WriteLine("[*] Subscriber starting...");

        var factory = new ConnectionFactory
        {
            HostName = Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? "rabbitmq",
            Port = int.Parse(Environment.GetEnvironmentVariable("RABBITMQ_PORT") ?? "5672"),
            UserName = Environment.GetEnvironmentVariable("RABBITMQ_USERNAME") ?? "guest",
            Password = Environment.GetEnvironmentVariable("RABBITMQ_PASSWORD") ?? "guest",
            DispatchConsumersAsync = true
        };

        using var connection = factory.CreateConnection();
        using var channel = connection.CreateModel();

        channel.ExchangeDeclare(ExchangeName, ExchangeType.Direct, durable: true);
        channel.QueueDeclare(QueueName, durable: true, exclusive: false, autoDelete: false);
        channel.QueueBind(QueueName, ExchangeName, RoutingKey);

        var emailService = new EmailService();
        var emailSender = new EmailSender(emailService);

        var consumer = new AsyncEventingBasicConsumer(channel);
        consumer.Received += async (sender, eventArgs) =>
        {
                var message = Encoding.UTF8.GetString(eventArgs.Body.ToArray());

                await emailSender.SendJobRecommendationEmailAsync(message);
            Console.WriteLine(" Email poslan.");

            channel.BasicAck(eventArgs.DeliveryTag, false);
        };

        channel.BasicConsume(QueueName, autoAck: false, consumer: consumer);

        Console.WriteLine(" [*] Waiting for messages. Service will stay alive...");
        await Task.Delay(-1); //  This keeps service alive forever
    }
}
