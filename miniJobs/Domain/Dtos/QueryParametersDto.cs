using Domain.Enums;

namespace Domain.Dtos;
public class QueryParametersDto
{
    public string SortBy { get; set; }
    public SortOrder SortOrder { get; set; }
    public int Limit { get; set; }
    public int Offset { get; set; }
    public string SearchText { get; set; }
}