using Microsoft.Extensions.Localization;

namespace Application.Common.Interfaces;

public interface ILocalizationService
{
    public LocalizedString GetLocalizedString(string key);
    public LocalizedString GetLocalizedString(string key, string parameter);
}