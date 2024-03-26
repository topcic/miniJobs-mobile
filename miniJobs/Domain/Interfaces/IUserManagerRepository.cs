using Domain.Entities;

namespace Domain.Interfaces;

public interface IUserManagerRepository : IGenericRepository<User, int>
{
    Task<User> TryFindByEmailAsync(string email);
    Task<IEnumerable<UserRole>> GetAllRolesAsync(int userId);
    Task<Role> TryFindRoleAsync(string roleId);
    Task<UserRole> AssignUserRoleAsync(User user, Role role);
}
