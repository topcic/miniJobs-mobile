using Domain.Enums;

namespace Application.Jobs.Models;

public class JobSearchRequest
{
    public string SearchText { get; set; }
    public int? CityId { get; set; }
    public int? JobTypeId { get; set; }
    public SortOrder SortOrder { get; set; }

}
