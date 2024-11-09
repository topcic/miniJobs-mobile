using Infrastructure.Options;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Options;

namespace Infrastructure.OptionsSetup;

public class MinijobsLocalizationOptionsSetup : IConfigureOptions<MinijobsLocalizationOptions>
{
    private readonly IConfiguration configuration;
    private const string SectionName = "Localization";

    public MinijobsLocalizationOptionsSetup(IConfiguration configuration)
    {
        this.configuration = configuration;
    }
    public void Configure(MinijobsLocalizationOptions options)
    {
        configuration.GetSection(SectionName).Bind(options);
    }
}
