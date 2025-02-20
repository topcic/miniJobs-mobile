using Domain.Enums;
using AutoMapper;
using Domain.Dtos;
using Microsoft.Data.SqlClient;
using System.Data;

namespace Infrastructure.Persistence.Repositories
{
    public class JobRepository(ApplicationDbContext context, IMapper mapper) : GenericRepository<Job, int, ApplicationDbContext>(context, mapper), IJobRepository
    {
        public async Task<Job> GetWithDetailsAsync(int id, bool isApplicant, int userId)
        {
            var job = await (from j in context.Jobs
                             join jt in context.JobTypes on j.JobTypeId equals jt.Id into jobTypeJoin
                             from jt in jobTypeJoin.DefaultIfEmpty()
                             join c in context.Cities on j.CityId equals c.Id into cityJoin
                             from c in cityJoin.DefaultIfEmpty()
                             join u in context.Users on j.CreatedBy equals u.Id into userJoin
                             from u in userJoin.DefaultIfEmpty()
                             where j.Id == id
                             select new
                             {
                                 Job = j,
                                 JobType = jt,
                                 City = c,
                                 EmployerFullName = u.FirstName + " " + u.LastName
                             }).FirstOrDefaultAsync();

            if (job == null)
            {
                return null;
            }

            var schedules = await (from jq in context.JobQuestions
                                   join qa in context.JobQuestionAnswers on jq.Id equals qa.JobQuestionId into qaJoin
                                   from qa in qaJoin.DefaultIfEmpty()
                                   join pa in context.ProposedAnswers on qa.ProposedAnswerId equals pa.Id into paJoin
                                   from pa in paJoin.DefaultIfEmpty()
                                   where jq.QuestionId == 1 && jq.JobId == id
                                   select pa).ToListAsync();

            var paymentQuestion = await (from jq in context.JobQuestions
                                         join qa in context.JobQuestionAnswers on jq.Id equals qa.JobQuestionId into qaJoin
                                         from qa in qaJoin.DefaultIfEmpty()
                                         join pa in context.ProposedAnswers on qa.ProposedAnswerId equals pa.Id into paJoin
                                         from pa in paJoin.DefaultIfEmpty()
                                         where jq.QuestionId == 2 && jq.JobId == id
                                         select pa).FirstOrDefaultAsync();

            var additionalPaymentOptions = await (from jq in context.JobQuestions
                                                  join qa in context.JobQuestionAnswers on jq.Id equals qa.JobQuestionId into qaJoin
                                                  from qa in qaJoin.DefaultIfEmpty()
                                                  join pa in context.ProposedAnswers on qa.ProposedAnswerId equals pa.Id into paJoin
                                                  from pa in paJoin.DefaultIfEmpty()
                                                  where jq.QuestionId == 3 && jq.JobId == id
                                                  select pa).ToListAsync();

            var result = job.Job;
            result.JobType = job.JobType;
            result.City = job.City;
            result.EmployerFullName = job.EmployerFullName;
            result.Schedules = schedules;
            result.PaymentQuestion = paymentQuestion;
            result.AdditionalPaymentOptions = additionalPaymentOptions;
            if (isApplicant)
            {
                var hasApplied = await context.JobApplications.AnyAsync(ja => ja.JobId == id && ja.CreatedBy == userId && ja.IsDeleted == false);
                var hasSaved = await context.SavedJobs.AnyAsync(sj => sj.JobId == id && sj.CreatedBy == userId && sj.IsDeleted == false);

                result.IsApplied = hasApplied;
                result.IsSaved = hasSaved;
            }

            return result;
        }


        public async Task<IEnumerable<Job>> GetEmployerJobsAsync(int employerId)
        {
            var jobs = from j in context.Jobs
                       where j.CreatedBy == employerId && j.Status != JobStatus.Inactive && j.DeletedByAdmin == false
                       orderby j.Created descending
                       select new
                       {
                           Job = j,
                           NumberOfApplications = context.JobApplications
                                                .Where(ja => ja.JobId == j.Id)
                                                .Count()
                       };

            var jobList = await jobs.ToListAsync();

            var result = jobList.Select(job => new Job
            {
                Id = job.Job.Id,
                Name = job.Job.Name,
                Description = job.Job.Description,
                CreatedBy = job.Job.CreatedBy,
                Created = job.Job.Created,
                Status = job.Job.Status,
                ApplicationsDuration = job.Job.ApplicationsDuration,
                RequiredEmployees = job.Job.RequiredEmployees,
                Wage = job.Job.Wage,
                CityId = job.Job.CityId,
                JobTypeId = job.Job.JobTypeId,
                NumberOfApplications = job.NumberOfApplications
            }).ToList();

            return result;
        }

        public async Task<IEnumerable<JobCardDTO>> SearchAsync(string searchText, int limit, int offset, int? cityId, Domain.Enums.SortOrder sort)
        {
            var query = context.Jobs
                .Where(j => (string.IsNullOrEmpty(searchText) || j.Name.Contains(searchText))
                             && (!cityId.HasValue || j.CityId == cityId)
                             && j.Status == JobStatus.Active
                             && !j.DeletedByAdmin)
                .Select(j => new JobCardDTO
                {
                    Id = j.Id,
                    Name = j.Name,
                    CityName = j.City.Name,
                    Wage = j.Wage,
                    Created = j.Created
                });

            var jobList = sort == Domain.Enums.SortOrder.DESC
                ? await query.OrderByDescending(j => j.Created)
                             .Skip(offset)
                             .Take(limit)
                             .ToListAsync()
                : await query.OrderBy(j => j.Created)
                             .Skip(offset)
                             .Take(limit)
                             .ToListAsync();

            return jobList;
        
        }


        public async Task<int> SearchCountAsync(string searchText, int? cityId)
        {
            var sqlQuery = @"
        SELECT COUNT(*)
        FROM jobs AS j
        WHERE (@searchText IS NULL OR j.name LIKE '%' + @searchText + '%')
          AND (@cityId IS NULL OR j.city_id = @cityId);
    ";
            await using var connection = new SqlConnection(context.Database.GetConnectionString());
            await connection.OpenAsync();

            await using var command = connection.CreateCommand();
            command.CommandText = sqlQuery;
            command.Parameters.Add(new SqlParameter("@searchText", (object)searchText ?? DBNull.Value));
            command.Parameters.Add(new SqlParameter("@cityId", (object)cityId ?? DBNull.Value));

            var count = (int)await command.ExecuteScalarAsync();
            return count;
        }

        public async Task<IEnumerable<JobCardDTO>> GetApplicantSavedJobsAsync(int applicantId)
        {
            var query = from j in context.Jobs
                        join sj in context.SavedJobs on j.Id equals sj.JobId
                        where sj.CreatedBy == applicantId && sj.IsDeleted == false && j.DeletedByAdmin == false
                        select new JobCardDTO
                        {
                            Id = j.Id,
                            Name = j.Name,
                            CityName =j.City.Name,
                            Wage = j.Wage
                        };

            return await query.ToListAsync();
        }

        public async Task<IEnumerable<JobApplication>> GetApplicantAppliedJobsAsync(int applicantId)
        {
            var query = from a in context.JobApplications
                        join j in context.Jobs on a.JobId equals j.Id
                        join c in context.Cities on j.CityId equals c.Id
                        join r in context.Ratings
                            on new { a.Id, a.CreatedBy }
                            equals new { Id = r.JobApplicationId, CreatedBy = r.CreatedBy }
                            into ratingsGroup
                        from r in ratingsGroup.DefaultIfEmpty()
                        where a.CreatedBy == applicantId && a.IsDeleted == false && j.DeletedByAdmin == false
                        select new JobApplication
                        {
                            Id = a.Id,
                            JobId = a.JobId,
                            Status = a.Status,
                            IsDeleted = a.IsDeleted,
                            Created = a.Created,
                            HasRated = r != null,
                            Job = new Job
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
                                CreatedBy = j.CreatedBy,
                                City = c // Include City information
                            }
                        };




            return await query.ToListAsync();
        }

        public async Task<IEnumerable<ApplicantDTO>> GetApplicants(int jobId, string role)
        {
            var isAdmin = role == "Administrator";
            var applicants = from j in context.Jobs
                             join ja in context.JobApplications on j.Id equals ja.JobId
                             join a in context.Applicants on ja.CreatedBy equals a.Id
                             join u in context.Users on a.Id equals u.Id
                             join c in context.Cities on u.CityId equals c.Id
                             where j.Id == jobId && (isAdmin || !j.DeletedByAdmin)
                             select new
                             {
                                 Applicant = a,
                                 User = u,
                                 City = c,
                                 ApplicantJobTypes = a.ApplicantJobTypes,
                                 JobApplicationId = ja.Id,
                                 ApplicationStatus = ja.Status
                             };

            var applicantDetails = from app in applicants
                                   let ratings = context.Ratings
                                                        .Where(r => r.RatedUserId == app.Applicant.Id)
                                                        .Select(r => (double)r.Value)
                                                        .ToList()
                                   let finishedJobsCount = (from ja in context.JobApplications
                                                            join j in context.Jobs on ja.JobId equals j.Id
                                                            where ja.CreatedBy == app.Applicant.Id && j.Status == JobStatus.Completed
                                                            select ja).Count()
                                   let isRated = context.Ratings
                                                       .Any(r => r.RatedUserId == app.Applicant.Id &&
                                                                 r.JobApplicationId == app.JobApplicationId)

                                   let jobApplication = (from ja in context.JobApplications
                                                         where ja.CreatedBy == app.Applicant.Id && ja.JobId == jobId
                                                         select ja).FirstOrDefault()
                                   select new ApplicantDTO
                                   {
                                       Id = app.Applicant.Id,
                                       Cv = app.Applicant.Cv,
                                       Experience = app.Applicant.Experience,
                                       Description = app.Applicant.Description,
                                       WageProposal = app.Applicant.WageProposal,
                                       FirstName = app.User.FirstName,
                                       LastName = app.User.LastName,
                                       Email = app.User.Email,
                                       PhoneNumber = app.User.PhoneNumber,
                                       Gender = app.User.Gender,
                                       DateOfBirth = app.User.DateOfBirth,
                                       CityId = app.User.CityId,
                                       Deleted = app.User.Deleted,
                                       CreatedBy = app.User.CreatedBy,
                                       Photo = app.User.Photo,
                                       Role = app.User.Role,
                                       ApplicantJobTypes = app.ApplicantJobTypes,
                                       City = app.City,
                                       AverageRating = ratings.Any() ? (decimal)ratings.Average() : 0,
                                       NumberOfFinishedJobs = finishedJobsCount,
                                       JobApplicationId = app.JobApplicationId,
                                       IsRated = isRated,
                                       ApplicationStatus = app.ApplicationStatus
                                   };

            var result = await applicantDetails.ToListAsync();
            return result;
        }

        public async Task<IEnumerable<Job>> GetJobsExpiringInTwoDaysAsync()
        {
            var twoDaysAgo = DateTime.UtcNow.AddDays(2);

            var query = from j in context.Jobs
                        where j.Status == JobStatus.Active && j.DeletedByAdmin == false
                        && EF.Functions.DateDiffDay(DateTime.UtcNow, j.Created.AddDays(j.ApplicationsDuration.Value)) == 2
                        select j;

            return await query.ToListAsync();
        }

        public async Task<IEnumerable<Job>> GetExpiredActiveJobsAsync()
        {
            var query = from j in context.Jobs
                        where j.Status == JobStatus.Active && j.DeletedByAdmin == false
                              && DateTime.UtcNow > j.Created.AddDays(j.ApplicationsDuration.Value)
                        select j;

            return await query.ToListAsync();
        }

        public async Task<int> PublicCountAsync(Dictionary<string, string> parameters = null)
        {
            var query = context.Jobs.AsQueryable();

            if (parameters != null && parameters.TryGetValue("searchText", out string searchText) && !string.IsNullOrWhiteSpace(searchText))
            {
                query = query.Where(j =>
                    j.Name.Contains(searchText) ||
                  j.Description.Contains(searchText)
               );
            }


            var count = await query.CountAsync();
            return count;
        }

        public async Task<IEnumerable<JobDTO>> PublicFindPaginationAsync(Dictionary<string, string> parameters = null)
        {
            var queryParameters = mapper.Map<QueryParametersDto>(parameters);

            // Base query selecting only necessary fields
            var query = from j in context.Jobs
                        where string.IsNullOrEmpty(queryParameters.SearchText) ||
                              j.Name.Contains(queryParameters.SearchText) ||
                              j.Description.Contains(queryParameters.SearchText)
                        select new
                        {
                            j.Id,
                            j.Name,
                            j.Description,
                            j.ApplicationsDuration,
                            j.Status,
                            j.RequiredEmployees,
                            j.Wage,
                            j.Created,
                            j.CreatedBy,
                            j.DeletedByAdmin,

                            // Related data
                            CityName = context.Cities.Where(c => c.Id == j.CityId)
                                                     .Select(c => c.Name)
                                                     .FirstOrDefault(),
                            JobTypeName = context.JobTypes.Where(jt => jt.Id == j.JobTypeId)
                                                          .Select(jt => jt.Name)
                                                          .FirstOrDefault(),

                            EmployerFullName = context.Employers.Where(e => e.Id == j.CreatedBy)
                                                                .Select(e => e.Name)
                                                                .FirstOrDefault() ??
                                               context.Users.Where(u => u.Id == j.CreatedBy)
                                                            .Select(u => u.FirstName + " " + u.LastName)
                                                            .FirstOrDefault()
                        };

            if (!string.IsNullOrEmpty(queryParameters.SortBy))
            {
                switch (queryParameters.SortBy.ToLower())
                {
                    case "name":
                        query = queryParameters.SortOrder == Domain.Enums.SortOrder.DESC
                            ? query.OrderByDescending(j => j.Name)
                            : query.OrderBy(j => j.Name);
                        break;
                    case "status":
                        query = queryParameters.SortOrder == Domain.Enums.SortOrder.DESC
                            ? query.OrderByDescending(j => j.Status)
                            : query.OrderBy(j => j.Status);
                        break;
                    case "created":
                        query = queryParameters.SortOrder == Domain.Enums.SortOrder.DESC
                            ? query.OrderByDescending(j => j.Created)
                            : query.OrderBy(j => j.Created);
                        break;
                    default:
                        query = query.OrderBy(j => j.Id); 
                        break;
                }
            }

            query = query.Skip(queryParameters.Offset).Take(queryParameters.Limit);

            var jobList = await query.ToListAsync();

            var result = jobList.Select(job => new JobDTO
            {
                Id = job.Id,
                Name = job.Name,
                Description = job.Description,
                ApplicationsDuration = job.ApplicationsDuration,
                Status = job.Status,
                RequiredEmployees = job.RequiredEmployees,
                CreatedBy = job.CreatedBy.Value,
                EmployerFullName = job.EmployerFullName,
                CityName = job.CityName,
                JobTypeName = job.JobTypeName,
                Created = job.Created,
                DeletedByAdmin = job.DeletedByAdmin
            }).ToList();

            return result;
        }
        public async Task<IEnumerable<Job>> GetJobsForReportsAsync()
        {
            var jobs = await (from j in context.Jobs
                              join jt in context.JobTypes on j.JobTypeId equals jt.Id into jobTypeJoin
                              from jt in jobTypeJoin.DefaultIfEmpty()
                              join c in context.Cities on j.CityId equals c.Id into cityJoin
                              from c in cityJoin.DefaultIfEmpty()
                              join u in context.Users on j.CreatedBy equals u.Id into userJoin
                              from u in userJoin.DefaultIfEmpty()
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
                                  Created = j.Created,
                                  CreatedBy = j.CreatedBy,
                                  JobType = jt, // Use jt (joined job type)
                                  City = c,     // Use c (joined city)
                                  EmployerFullName = u != null ? u.FirstName + " " + u.LastName : null
                              }).ToListAsync();

            return jobs;
        }
    }

}
