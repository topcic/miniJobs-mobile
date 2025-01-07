using Infrastructure.Options;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Options;

namespace Infrastructure.OptionsSetup;

public class AuthCodeOptionsSetup(IConfiguration configuration) : IConfigureOptions<AuthCodeOptions>
{
    private const string SectionName = "AuthCodeOptions";

    public void Configure(AuthCodeOptions options)
    {
        configuration.GetSection(SectionName).Bind(options);
    }
}