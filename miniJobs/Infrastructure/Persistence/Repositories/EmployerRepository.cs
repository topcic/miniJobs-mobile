using Application.Common.Exceptions;
using AutoMapper;
using Domain.Dtos;
using Domain.Entities;
using Domain.Enums;

namespace Infrastructure.Persistence.Repositories;

public class EmployerRepository(ApplicationDbContext _context, IMapper mapper) : GenericRepository<Employer, int, ApplicationDbContext>(_context, mapper), IEmployerRepository
{
    public async  Task<IEnumerable<Job>> GetActiveJobs(int userId, int requestedBy)
    {
        IQueryable<Job> query;
        if(requestedBy == userId) 
            query = from j in _context.Jobs
                    join c in _context.Cities on j.CityId equals c.Id
                    where j.Status == JobStatus.Active
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
                        JobTypeId = j.JobTypeId,
                        City = c 
                    };
        else
            query = from j in _context.Jobs
                    join c in _context.Cities on j.CityId equals c.Id
                    join a in _context.JobApplications on j.Id equals a.JobId into jobApplications
                    from ja in jobApplications.DefaultIfEmpty()
                    join s in _context.SavedJobs on j.Id equals s.JobId into savedJobs
                    from sj in savedJobs.DefaultIfEmpty()
                    where j.Status == JobStatus.Active
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

    public async Task<int> PublicCountAsync(Dictionary<string, string> parameters = null)
    {

        var query = _context.Employers
            .Include(a => a.User) // Ensure navigation properties are directly accessible
            .ThenInclude(u => u.City)
            .AsQueryable();

        if (parameters != null && parameters.TryGetValue("searchText", out string searchText) && !string.IsNullOrWhiteSpace(searchText))
        {
            query = query.Where(a =>
               (a.User.LastName != null && a.User.LastName.Contains(searchText)) ||
               (a.User.FirstName != null && a.User.FirstName.Contains(searchText)) ||
               (a.User.Email != null && a.User.Email.Contains(searchText)) ||
               (a.User.PhoneNumber != null && a.User.PhoneNumber.Contains(searchText))
           );
        }


        var count = await query.CountAsync();
        return count;
    }

    public async Task<IEnumerable<EmployerDTO>> PublicFindPaginationAsync(Dictionary<string, string> parameters = null)
    {
        var queryParameters = mapper.Map<QueryParametersDto>(parameters);

        var query = _context.Employers.AsQueryable();

        // Apply search filters
        if (!string.IsNullOrEmpty(queryParameters.SearchText))
        {
            query = query.Where(a =>
               (a.User.LastName != null && a.User.LastName.Contains(queryParameters.SearchText)) ||
               (a.User.FirstName != null && a.User.FirstName.Contains(queryParameters.SearchText)) ||
               (a.User.Email != null && a.User.Email.Contains(queryParameters.SearchText)) ||
               (a.User.PhoneNumber != null && a.User.PhoneNumber.Contains(queryParameters.SearchText))
           );
        }

        // Apply sorting
        if (!string.IsNullOrEmpty(queryParameters.SortBy))
        {
            string columnName = QueryParameterExtension.GetMappedColumnName(queryParameters.SortBy, typeof(User));
            query = columnName switch
            {
                "FirstName" => queryParameters.SortOrder == Domain.Enums.SortOrder.DESC
                    ? query.OrderByDescending(a => a.User.FirstName)
                    : query.OrderBy(a => a.User.FirstName),
                "LastName" => queryParameters.SortOrder == Domain.Enums.SortOrder.DESC
                    ? query.OrderByDescending(a => a.User.LastName)
                    : query.OrderBy(a => a.User.LastName),
                "Email" => queryParameters.SortOrder == Domain.Enums.SortOrder.DESC
                    ? query.OrderByDescending(a => a.User.Email)
                    : query.OrderBy(a => a.User.Email),
                "PhoneNumber" => queryParameters.SortOrder == Domain.Enums.SortOrder.DESC
                    ? query.OrderByDescending(a => a.User.PhoneNumber)
                    : query.OrderBy(a => a.User.PhoneNumber),
                "Deleted" => queryParameters.SortOrder == Domain.Enums.SortOrder.DESC
                  ? query.OrderByDescending(a => a.User.Deleted)
                  : query.OrderBy(a => a.User.Deleted),
                _ => throw new ArgumentException($"Invalid SortBy value: {queryParameters.SortBy}")
            };
        }

        // Apply pagination
        query = query.Skip(queryParameters.Offset).Take(queryParameters.Limit);

        // Include related data
        query = query.Include(a => a.User)
                     .Include(a => a.User.City);

        // Fetch and project data
        var results = await query
            .Select(a => new
            {
                Employer = a,
                AverageRating = _context.Ratings
                                        .Where(r => r.RatedUserId == a.Id)
                                        .Select(r => (double?)r.Value)
                                        .Average() ?? 0,
                NumberOfFinishedJobs = (from ja in _context.JobApplications
                                        join j in _context.Jobs on ja.JobId equals j.Id
                                        where ja.CreatedBy == a.Id && j.Status == JobStatus.Completed
                                        select ja).Count()
            })
            .ToListAsync();

        // Map results to EmployerDTO
        var employerDtos = new List<EmployerDTO>();

        foreach (var result in results)
        {
            var employerWithUser = await (from e in _context.Employers
                                          join u in _context.Users on e.Id equals u.Id
                                          where e.Id == result.Employer.Id
                                          select new { Employer = e, User = u })
                                          .FirstOrDefaultAsync();

            if (employerWithUser != null)
            {
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
                    City = await _context.Cities.FindAsync(employerWithUser.User.CityId) ?? null,
                    AverageRating = (decimal)Math.Round(result.AverageRating, 2)
                };

                employerDtos.Add(employerDto);
            }
        }

        return employerDtos;
    }

}
