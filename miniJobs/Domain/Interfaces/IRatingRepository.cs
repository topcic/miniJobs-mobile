using Domain.Entities;

namespace Domain.Interfaces;
public interface IRatingRepository : IGenericRepository<Rating, int>
{
    Task<IEnumerable<Rating>> GetRatingsForReportsAsync();
}
