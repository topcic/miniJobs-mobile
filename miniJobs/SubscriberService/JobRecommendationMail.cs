using System.Text.Json.Serialization;

namespace SubscriberService;

public class JobRecommendationMail
{
    [JsonPropertyName("fullName")]
    public string FullName { get; set; }

    [JsonPropertyName("mail")]
    public string Mail { get; set; }

    [JsonPropertyName("jobName")]
    public string JobName { get; set; }
}


