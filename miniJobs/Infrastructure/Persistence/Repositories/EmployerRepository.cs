using Microsoft.EntityFrameworkCore;

namespace Infrastructure.Persistence.Repositories;

public class EmployerRepository(ApplicationDbContext _context) : GenericRepository<Employer, int, ApplicationDbContext>(_context), IEmployerRepository
{
    public async Task<Employer> GetWithDetailsAsync(int employerId)
    {
        var employerWithUser = await (from e in _context.Employers
                                      join u in _context.Users on e.Id equals u.Id
                                      where e.Id == employerId
                                      select new { Employer = e, User = u })
                                      .FirstOrDefaultAsync();

        if (employerWithUser == null)
        {
            return null;
        }

        var ratings = await _context.Ratings
                                    .Where(r => r.RatedUserId == employerWithUser.Employer.Id)
                                    .Select(r => (double)r.Value)
                                    .ToListAsync();

        double averageRating = ratings.Any() ? ratings.Average() : 0;

        employerWithUser.Employer.AverageRating = (decimal)Math.Round(averageRating, 2);
        employerWithUser.Employer.User = employerWithUser.User;

        return employerWithUser.Employer;
    }
}
