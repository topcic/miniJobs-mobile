

using Domain.Dtos;
using Domain.Enums;
using Microsoft.Data.SqlClient;

namespace Infrastructure.Persistence.Repositories;

public class ApplicantRepository(ApplicationDbContext context) : GenericRepository<Applicant, int, ApplicationDbContext>(context), IApplicantRepository
{
    private readonly ApplicationDbContext _context = context;

    public async Task<ApplicantDTO> GetWithDetailsAsync(int id)
    {
        var applicant = await _context.Applicants
            .Include(a => a.User)
            .Include(a => a.User.City)
            .Include(a => a.ApplicantJobTypes)
                .ThenInclude(ajt => ajt.JobType)
            .FirstOrDefaultAsync(a => a.Id == id);

        if (applicant == null)
        {
            return null;
        }

        var averageRating = await _context.Ratings
            .Where(r => r.RatedUserId == applicant.Id)
            .Select(r => (double?)r.Value)
            .AverageAsync() ?? 0;

        var numberOfFinishedJobs = await (from ja in _context.JobApplications
                                          join j in _context.Jobs on ja.JobId equals j.Id
                                          where ja.CreatedBy == applicant.Id && j.Status == (int)JobStatus.Completed
                                          select ja).CountAsync();

        return new ApplicantDTO
        {
            Id = applicant.Id,
            Cv = applicant.Cv,
            Experience = applicant.Experience,
            Description = applicant.Description,
            WageProposal = applicant.WageProposal,
            Created = applicant.User.Created,
            FirstName = applicant.User.FirstName,
            LastName = applicant.User.LastName,
            Email = applicant.User.Email,
            PhoneNumber = applicant.User.PhoneNumber,
            Gender = applicant.User.Gender,
            DateOfBirth = applicant.User.DateOfBirth,
            CityId = applicant.User.CityId,
            Deleted = applicant.User.Deleted,
            CreatedBy = applicant.User.CreatedBy,
            Photo = applicant.User.Photo,
            Role = applicant.User.Role,
            ApplicantJobTypes = applicant.ApplicantJobTypes,
            City = applicant.User.City,
            AverageRating = (decimal)averageRating,
            NumberOfFinishedJobs = numberOfFinishedJobs
        };
    }


    public async Task<IEnumerable<ApplicantDTO>> SearchAsync(string searchText, int limit, int offset, int? cityId, int? jobTypeId)
    {
        var query = _context.Applicants.AsQueryable();

        if (!string.IsNullOrEmpty(searchText))
        {
            query = query.Where(a =>
                (a.User.LastName != null && a.User.LastName.Contains(searchText)) ||
                (a.User.FirstName != null && a.User.FirstName.Contains(searchText))
            );
        }

        if (cityId.HasValue)
        {
            query = query.Where(a => a.User.CityId == cityId.Value);
        }

        if (jobTypeId.HasValue)
        {
            query = query.Where(a => a.ApplicantJobTypes.Any(ajt => ajt.JobTypeId == jobTypeId.Value));
        }

        query = query.Skip(offset).Take(limit);

        query = query.Include(a => a.User)
                     .Include(a => a.User.City)
                     .Include(a => a.ApplicantJobTypes)
                     .ThenInclude(ajt => ajt.JobType);

        var result = await query.Select(a => new
        {
            Applicant = a,
            AverageRating = _context.Ratings
                                    .Where(r => r.RatedUserId == a.Id)
                                    .Select(r => (double?)r.Value)
                                    .Average() ?? 0,
            NumberOfFinishedJobs = (from ja in _context.JobApplications
                                    join j in _context.Jobs on ja.JobId equals j.Id
                                    where ja.CreatedBy == a.Id && j.Status == (int)JobStatus.Completed
                                    select ja)
                                      .Count()
        })
        .ToListAsync();

        return result.Select(x => new ApplicantDTO
        {
            Id = x.Applicant.Id,
            Cv = x.Applicant.Cv,
            Experience = x.Applicant.Experience,
            Description = x.Applicant.Description,
            WageProposal = x.Applicant.WageProposal,
            Created = x.Applicant.User.Created,
            FirstName = x.Applicant.User.FirstName,
            LastName = x.Applicant.User.LastName,
            Email = x.Applicant.User.Email,
            PhoneNumber = x.Applicant.User.PhoneNumber,
            Gender = x.Applicant.User.Gender,
            DateOfBirth = x.Applicant.User.DateOfBirth,
            CityId = x.Applicant.User.CityId,
            Deleted = x.Applicant.User.Deleted,
            CreatedBy = x.Applicant.User.CreatedBy,
            Photo = x.Applicant.User.Photo,
            Role = x.Applicant.User.Role,
            ApplicantJobTypes = x.Applicant.ApplicantJobTypes,
            City = x.Applicant.User.City,
            AverageRating = (decimal)x.AverageRating,
            NumberOfFinishedJobs = x.NumberOfFinishedJobs
        });
    }

    public async Task<int> SearchCountAsync(string searchText, int? cityId, int? jobTypeId)
    {
        var query = context.Applicants.AsQueryable();
        if (!string.IsNullOrEmpty(searchText))
        {
            query = query.Where(a =>
                (a.User.LastName != null && a.User.LastName.Contains(searchText)) ||
                (a.User.FirstName != null && a.User.FirstName.Contains(searchText))
            );
        }
        if (cityId.HasValue)
        {
            query = query.Where(a => a.User.CityId == cityId.Value);
        }
        if (jobTypeId.HasValue)
        {
            query = query.Where(a => a.ApplicantJobTypes.Any(ajt => ajt.JobTypeId == jobTypeId.Value));
        }

        var count = await query.CountAsync();

        return count;
    }
}