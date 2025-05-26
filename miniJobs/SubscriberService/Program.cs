using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using System.Text;

using SubscribeService; 

var factory = new ConnectionFactory
{
    HostName = Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? "localhost",
    Port = int.Parse(Environment.GetEnvironmentVariable("RABBITMQ_PORT") ?? "5672"),
    UserName = Environment.GetEnvironmentVariable("RABBITMQ_USERNAME") ?? "guest",
    Password = Environment.GetEnvironmentVariable("RABBITMQ_PASSWORD") ?? "guest",
    ClientProvidedName = "Rabbit Test Consumer"
};

using var connection = factory.CreateConnection();
using var channel = connection.CreateModel();

string exchangeName = "EmailExchange";
channel.ExchangeDeclare(exchangeName, ExchangeType.Direct);

// Declare and bind expiry queue
string expiryQueueName = "application-expiry-email-queue";
string expiryRoutingKey = "application-expiry-email";
channel.QueueDeclare(expiryQueueName, true, false, false, null);
channel.QueueBind(expiryQueueName, exchangeName, expiryRoutingKey, null);

// Declare and bind recommendation queue
string recommendationQueueName = "job-recommendation-email-queue";
string recommendationRoutingKey = "job-recommendation-email";
channel.QueueDeclare(recommendationQueueName, true, false, false, null);
channel.QueueBind(recommendationQueueName, exchangeName, recommendationRoutingKey, null);

// Create EmailService instance (ideally this should come from DI)
var emailService = new EmailService();
var emailSender = new EmailSender(emailService);

// Consumer for expiry emails
var expiryConsumer = new EventingBasicConsumer(channel);
expiryConsumer.Received += async (sender, args) =>
{
    try
    {
        var body = args.Body.ToArray();
        string message = Encoding.UTF8.GetString(body);
        Console.WriteLine($" [*] Expiry message received: {message}");

        var parts = message.Split('|');
        if (parts.Length == 3)
        {
            await emailSender.SendJobExpiringReminderEmailAsync(parts[0], parts[1], parts[2]);
        }
        else
        {
            Console.WriteLine($" [!] Invalid message format: {message}");
        }

        channel.BasicAck(args.DeliveryTag, false);
    }
    catch (Exception ex)
    {
        Console.WriteLine($" [!] Error processing expiry message: {ex.Message}");
        // Optionally implement retry logic or move to dead-letter queue
        channel.BasicNack(args.DeliveryTag, false, true);
    }
};
channel.BasicConsume(expiryQueueName, false, expiryConsumer);

// Consumer for recommendation emails
var recommendationConsumer = new EventingBasicConsumer(channel);
recommendationConsumer.Received += async (sender, args) =>
{
    try
    {
        var body = args.Body.ToArray();
        string message = Encoding.UTF8.GetString(body);
        Console.WriteLine($" [*] Recommendation message received: {message}");

        var parts = message.Split('|');
        if (parts.Length == 3)
        {
            await emailSender.SendJobRecommendationEmailAsync(parts[0], parts[1], parts[2]);
        }
        else
        {
            Console.WriteLine($" [!] Invalid message format: {message}");
        }

        channel.BasicAck(args.DeliveryTag, false);
    }
    catch (Exception ex)
    {
        Console.WriteLine($" [!] Error processing recommendation message: {ex.Message}");
        // Optionally implement retry logic or move to dead-letter queue
        channel.BasicNack(args.DeliveryTag, false, true);
    }
};
channel.BasicConsume(recommendationQueueName, false, recommendationConsumer);

Console.WriteLine(" [*] Waiting for messages. Press [enter] to quit.");
Console.ReadLine();

channel.Close();
connection.Close();