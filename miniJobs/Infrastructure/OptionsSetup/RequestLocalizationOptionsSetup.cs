using Infrastructure.Options;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Localization;
using Microsoft.Extensions.Options;
using System.Globalization;

namespace Infrastructure.OptionsSetup;

public class RequestLocalizationOptionsSetup : IConfigureNamedOptions<RequestLocalizationOptions>
{
    private readonly MinijobsLocalizationOptions localizationOptions;

    public RequestLocalizationOptionsSetup(IOptions<MinijobsLocalizationOptions> localizationOptions)
    {
        this.localizationOptions = localizationOptions.Value;
    }

    public void Configure(string name, RequestLocalizationOptions options)
    {
        options.DefaultRequestCulture = new RequestCulture(culture: localizationOptions.DefaultCulture, uiCulture: localizationOptions.DefaultCulture);

        List<CultureInfo> locales = new List<CultureInfo>();

        foreach (var culture in localizationOptions.SupportedCultures)
            locales.Add(new CultureInfo(culture));

        options.SupportedCultures = locales;
        options.SupportedUICultures = locales;
    }

    public void Configure(RequestLocalizationOptions options)
    {
        Configure(null, options);
    }
}