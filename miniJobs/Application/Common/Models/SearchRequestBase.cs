using Domain.Enums;

namespace Application.Common.Models;
public class SearchRequestBase
{
    public string SearchText { get; set; }
    public int Limit { get; set; }
    public int Offset { get; set; }
    public string SortBy { get; set; }
    public SortOrder? SortOrder { get; set; }
}