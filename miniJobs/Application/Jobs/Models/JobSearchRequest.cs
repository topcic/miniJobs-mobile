using Domain.Enums;

namespace Application.Jobs.Models;

public class JobSearchRequest
{
    public string SearchText { get; set; }
    public int? CityId { get; set; }
    public SortOrder SortOrder { get; set; }
    public int Limit { get; set; }
    public int Offset { get; set; }
}
