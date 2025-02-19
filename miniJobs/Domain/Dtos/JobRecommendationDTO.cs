namespace Domain.Dtos;

public record JobRecommendationDTO
{
    public string ApplicantFullName { get; set; }
    public int CreatedBy { get; set; }
    public List<string> JobTypes { get; set; }
    public List<string> Cities { get; set; }
}
