namespace Infrastructure.Options;
public class BackgroundJobServiceOptions
{
    public string Name { get; set; }
    public string Cron { get; set; }
    public bool Enabled { get; set; }
}
