using Infrastructure.Options;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Options;

namespace Infrastructure.OptionsSetup;

internal class BackgroundJobServicesOptionsSetup : IConfigureOptions<BackgroundJobServicesOptions>
{

    private const string SectionName = "BackgroundJobServices";
    private readonly IConfiguration configuration;
    public BackgroundJobServicesOptionsSetup(IConfiguration configuration)
    {
        this.configuration = configuration;
    }
    public void Configure(BackgroundJobServicesOptions options)
    {
        configuration.GetSection(SectionName).Bind(options);
    }

}