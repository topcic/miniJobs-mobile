using Infrastructure.Options;
using Microsoft.Extensions.Localization;
using Microsoft.Extensions.Options;

namespace Infrastructure.OptionsSetup;

public class LocalizationOptionsSetup : IConfigureNamedOptions<LocalizationOptions>
{
    MinijobsLocalizationOptions minijobsLocalizationOptions;

    public LocalizationOptionsSetup(IOptions<MinijobsLocalizationOptions> options)
    {
        minijobsLocalizationOptions = options.Value;
    }

    public void Configure(string name, LocalizationOptions options)
    {
        options.ResourcesPath = minijobsLocalizationOptions.ResourcesPath;
    }

    public void Configure(LocalizationOptions options)
    {
        Configure(null, options);
    }
}