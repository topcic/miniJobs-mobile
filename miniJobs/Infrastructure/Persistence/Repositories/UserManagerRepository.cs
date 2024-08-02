using Domain.Entities;
using Domain.Enums;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Any;
using Newtonsoft.Json.Linq;

namespace Infrastructure.Persistence.Repositories;

public class UserManagerRepository(ApplicationDbContext context) : GenericRepository<User, int, ApplicationDbContext>(context), IUserManagerRepository
{
    private ApplicationDbContext context = context;
    protected readonly DbSet<User> dbSet = context.Set<User>();
    public async Task<User> TryFindByEmailAsync(string email)
    {
        return await dbSet.SingleOrDefaultAsync(x => x.Email == email);
    }

    public async Task<IEnumerable<UserRole>> GetAllRolesAsync(int userId)
    {
        return dbSet.Where(x => x.Id == userId)
            .Join(context.Set<UserRole>(),
             u => u.Id,
             ur => ur.UserId,
             (u, ur) => ur).AsEnumerable();
    }

    public async Task<Role> TryFindRoleAsync(string roleId)
    {
        return await context.Set<Role>().FirstOrDefaultAsync(x => x.Id == roleId);
    }

    public async Task<UserRole> AssignUserRoleAsync(User user, Role role)
    {
        var userRole = new UserRole()
        {
            UserId = user.Id,
            RoleId = role.Id,
        };
        await context.Set<UserRole>().AddAsync(userRole);
        await context.SaveChangesAsync();
        return userRole;
    }

    public async Task<IEnumerable<Rating>> GetRatings(int userId)
    {
        var ratings = await (from r in context.Ratings
                             join u in context.Users on r.CreatedBy equals u.Id
                             where r.RatedUserId == userId
                             select new Rating
                             {
                                 Id = r.Id,
                                 Value = r.Value,
                                 Comment = r.Comment,
                                 JobApplicationId = r.JobApplicationId,
                                 RatedUserId = r.RatedUserId,
                                 Created = r.Created,
                                 CreatedByFullName = u.FirstName + " " + u.LastName,
                                 Photo = u.Photo,
                                 CreatedBy = r.CreatedBy

                             }).ToListAsync();

        return ratings;
    }

    public async Task<IEnumerable<Job>> GetFinishedJobs(int userId, bool isApplicant)
    {
        IQueryable<Job> query;
        if (isApplicant)
        {
            query = from j in context.Jobs
                    join a in context.JobApplications on j.Id equals a.JobId
                    join c in context.Cities on j.CityId equals c.Id
                    where a.Status == JobApplicationStatus.Accepted
                          && a.CreatedBy == userId
                          && j.Status == JobStatus.Completed
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
        }
        else
        {
            query = from j in context.Jobs
                    join c in context.Cities on j.CityId equals c.Id
                    where j.Status == JobStatus.Completed
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
                        City = c // Include City information
                    };
        }
        return await query.ToListAsync();
    }
    public override async Task<User> TryFindAsync(int id)
    {
        var user = await (from u in DbSet
                          join ur in Context.Set<UserRole>() on u.Id equals ur.UserId into userRoles
                          from ur in userRoles.DefaultIfEmpty()
                          join e in Context.Set<Employer>() on u.Id equals e.Id into employers
                          from e in employers.DefaultIfEmpty()
                          where u.Id == id
                          select new User
                          {
                              Id = u.Id,
                              FirstName = u.FirstName,
                              LastName = u.LastName,
                              Email = u.Email,
                              PhoneNumber = u.PhoneNumber,
                              Gender = u.Gender,
                              DateOfBirth = u.DateOfBirth,
                              CityId = u.CityId,
                              Deleted = u.Deleted,
                              AccountConfirmed = u.AccountConfirmed,
                              PasswordHash = u.PasswordHash,
                              AccessFailedCount = u.AccessFailedCount,
                              Created = u.Created,
                              CreatedBy = u.CreatedBy,
                              Photo = u.Photo,
                              Role = ur.RoleId, 
                              Employer = e 
                          })
                     .SingleOrDefaultAsync();

        if (user == null)
        {
            return null; 
        }

      
        if (user.Role != null)
        {
            if (user.Role == "Applicant")
            {
                user.FullName = $"{user.FirstName} {user.LastName}";
            }
            else if (user.Role == "Employer")
            {
                if (!string.IsNullOrEmpty(user.Employer?.Name))
                {
                    user.FullName = user.Employer.Name;
                }
                else
                {
                    user.FullName = $"{user.FirstName} {user.LastName}";
                }
            }
            else
            {
                user.FullName = $"{user.FirstName} {user.LastName}";
            }
        }
        else
        {
            user.FullName = $"{user.FirstName} {user.LastName}";
        }

        return user;
    }

}