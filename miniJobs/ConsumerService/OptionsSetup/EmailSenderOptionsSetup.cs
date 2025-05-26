using ConsumerService.Options;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Options;

namespace ConsumerService.OptionsSetup;

public class EmailSenderOptionsSetup(IConfiguration configuration) : IConfigureOptions<EmailSenderOptions>
{
    private const string SectionName = "EmailSender";

    private readonly IConfiguration configuration = configuration;

    public void Configure(EmailSenderOptions options)
    {
        configuration.GetSection(SectionName).Bind(options);
    }
}