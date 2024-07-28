using Domain.Dtos;
using Domain.Enums;

namespace Infrastructure.Persistence.Repositories;

public class EmployerRepository(ApplicationDbContext _context) : GenericRepository<Employer, int, ApplicationDbContext>(_context), IEmployerRepository
{
    public async  Task<IEnumerable<Job>> GetActiveJobs(int userId, int requestedBy)
    {
        IQueryable<Job> query;
        if(requestedBy == userId) 
            query = from j in _context.Jobs
                    join c in _context.Cities on j.CityId equals c.Id
                    where j.Status == (int)JobStatus.Active
                    select new Job
                    {
                        Id = j.Id,
                        Name = j.Name,
                        Description = j.Description,
                        StreetAddressAndNumber = j.StreetAddressAndNumber,
                        ApplicationsDuration = j.ApplicationsDuration,
                        Status = j.Status,
                        RequiredEmployees = j.RequiredEmployees,
                        Wage = j.Wage,
                        CityId = j.CityId,
                        State = j.State,
                        JobTypeId = j.JobTypeId,
                        City = c 
                    };
        else
            /*
             join a in context.JobApplications on j.Id equals a.JobId into jobApplications
            from ja in jobApplications.DefaultIfEmpty()
            join s in context.SavedJobs on j.Id equals s.JobId into savedJobs
            from sj in savedJobs.DefaultIfEmpty()
             */
            query = from j in _context.Jobs
                    join c in _context.Cities on j.CityId equals c.Id
                    join a in _context.JobApplications on j.Id equals a.JobId into jobApplications
                    from ja in jobApplications.DefaultIfEmpty()
                    join s in _context.SavedJobs on j.Id equals s.JobId into savedJobs
                    from sj in savedJobs.DefaultIfEmpty()
                    where j.Status == (int)JobStatus.Active
                    select new Job
                    {
                        Id = j.Id,
                        Name = j.Name,
                        Description = j.Description,
                        StreetAddressAndNumber = j.StreetAddressAndNumber,
                        ApplicationsDuration = j.ApplicationsDuration,
                        Status = j.Status,
                        RequiredEmployees = j.RequiredEmployees,
                        Wage = j.Wage,
                        CityId = j.CityId,
                        State = j.State,
                        JobTypeId = j.JobTypeId,
                        City = c,
                        IsSaved = sj != null && sj.CreatedBy == userId,
                        IsApplied = ja != null && ja.CreatedBy == userId
                    };
        return await query.ToListAsync();
    }

    public async Task<EmployerDTO> GetWithDetailsAsync(int employerId)
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

        // Fetch ratings and calculate average rating
        var ratings = await _context.Ratings
                                    .Where(r => r.RatedUserId == employerWithUser.Employer.Id)
                                    .Select(r => (double)r.Value)
                                    .ToListAsync();

        double averageRating = ratings.Any() ? ratings.Average() : 0;

        // Populate EmployerDTO
        var employerDto = new EmployerDTO
        {
            Id = employerWithUser.Employer.Id,
            Name = employerWithUser.Employer.Name,
            StreetAddressAndNumber = employerWithUser.Employer.StreetAddressAndNumber,
            IdNumber = employerWithUser.Employer.IdNumber,
            CompanyPhoneNumber = employerWithUser.Employer.CompanyPhoneNumber,
            Created = employerWithUser.User.Created,
            FirstName = employerWithUser.User.FirstName,
            LastName = employerWithUser.User.LastName,
            Email = employerWithUser.User.Email,
            PhoneNumber = employerWithUser.User.PhoneNumber,
            Gender = employerWithUser.User.Gender,
            DateOfBirth = employerWithUser.User.DateOfBirth,
            CityId = employerWithUser.User.CityId,
            Deleted = employerWithUser.User.Deleted,
            CreatedBy = employerWithUser.User.CreatedBy,
            Photo = employerWithUser.User.Photo,
            Role = employerWithUser.User.Role,
            City = await _context.Cities.FindAsync(employerWithUser.User.CityId) ??null,
            AverageRating = (decimal)Math.Round(averageRating, 2)
        };

        return employerDto;
    }
}
