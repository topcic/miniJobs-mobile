using Domain.Entities;

namespace Domain.Interfaces;
public interface ITokenRepository : IGenericRepository<RefreshToken, string>
{
    Task DeleteAllByUserAsync(int userId);
}