namespace ConsumerService.Options;

public class EmailSenderOptions
{
    public string? Key { get; set; }
    public string? MailAddress { get; set; }
    public int? Port { get; set; }
    public string? ProviderEmail { get; set; }

}