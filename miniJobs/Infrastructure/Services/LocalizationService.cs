using Application.Common.Interfaces;
using Microsoft.Extensions.Localization;
using System.Reflection;

namespace Infrastructure.Services;

public class LocalizationService : ILocalizationService
{
    private readonly IStringLocalizer _localizer;

    public LocalizationService(IStringLocalizerFactory factory)
    {
        _localizer = factory.Create("Translations", Assembly.GetExecutingAssembly().FullName!);
    }

    public LocalizedString GetLocalizedString(string key)
    {
        var x = _localizer[key];
        return _localizer[key];
    }

    public LocalizedString GetLocalizedString(string key, string parameter)
    {
        return _localizer[key, parameter];
    }
}