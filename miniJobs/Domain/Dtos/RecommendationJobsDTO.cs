namespace Domain.Dtos;

public record RecommendationJobsDTO
{
    public IEnumerable<JobCardDTO> Jobs{ get; set; }
    public string Reason { get; set; }
}
