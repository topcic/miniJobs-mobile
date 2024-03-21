namespace Application.Common.Models;
public class SearchResponseBase<T>
{
    public IEnumerable<T> Result { get; set; }
    public int Count { get; set; }
}