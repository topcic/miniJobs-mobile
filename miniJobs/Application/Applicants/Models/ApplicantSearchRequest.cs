namespace Application.Applicants.Models;

public class ApplicantSearchRequest
{
    public string SearchText { get; set; }
    public int? CityId { get; set; }
    public int? JobTypeId { get; set; }
    public int Limit { get; set; }
    public int Offset { get; set; }
}
