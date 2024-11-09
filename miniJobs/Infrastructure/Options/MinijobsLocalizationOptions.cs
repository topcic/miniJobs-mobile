namespace Infrastructure.Options;

public class MinijobsLocalizationOptions
{
    public string DefaultCulture { get; set; } = string.Empty;

    public IEnumerable<string> SupportedCultures { get; set; } = new List<string>();

    public string ResourcesPath { get; set; } = string.Empty;
}