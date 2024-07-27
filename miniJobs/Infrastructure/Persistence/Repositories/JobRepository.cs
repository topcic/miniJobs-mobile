using Application.Applicants.Models;
using Domain.Dtos;
using Domain.Entities;
using Domain.Enums;
using Microsoft.Data.SqlClient;
using Newtonsoft.Json;
using System.Data;
using System.Data.Common;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

namespace Infrastructure.Persistence.Repositories
{
    public class JobRepository : GenericRepository<Job, int, ApplicationDbContext>, IJobRepository
    {
        private readonly ApplicationDbContext _context;

        public JobRepository(ApplicationDbContext context) : base(context)
        {
            _context = context;
        }

        public async Task<Job> GetWithDetailsAsync(int id, bool isApplicant, int userId)
        {
            var job = await (from j in _context.Jobs
                             join jt in _context.JobTypes on j.JobTypeId equals jt.Id into jobTypeJoin
                             from jt in jobTypeJoin.DefaultIfEmpty()
                             join c in _context.Cities on j.CityId equals c.Id into cityJoin
                             from c in cityJoin.DefaultIfEmpty()
                             join u in _context.Users on j.CreatedBy equals u.Id into userJoin
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

            var schedules = await (from jq in _context.JobQuestions
                                   join qa in _context.JobQuestionAnswers on jq.Id equals qa.JobQuestionId into qaJoin
                                   from qa in qaJoin.DefaultIfEmpty()
                                   join pa in _context.ProposedAnswers on qa.ProposedAnswerId equals pa.Id into paJoin
                                   from pa in paJoin.DefaultIfEmpty()
                                   where jq.QuestionId == 1 && jq.JobId == id
                                   select pa).ToListAsync();

            var paymentQuestion = await (from jq in _context.JobQuestions
                                         join qa in _context.JobQuestionAnswers on jq.Id equals qa.JobQuestionId into qaJoin
                                         from qa in qaJoin.DefaultIfEmpty()
                                         join pa in _context.ProposedAnswers on qa.ProposedAnswerId equals pa.Id into paJoin
                                         from pa in paJoin.DefaultIfEmpty()
                                         where jq.QuestionId == 2 && jq.JobId == id
                                         select pa).FirstOrDefaultAsync();

            var additionalPaymentOptions = await (from jq in _context.JobQuestions
                                                  join qa in _context.JobQuestionAnswers on jq.Id equals qa.JobQuestionId into qaJoin
                                                  from qa in qaJoin.DefaultIfEmpty()
                                                  join pa in _context.ProposedAnswers on qa.ProposedAnswerId equals pa.Id into paJoin
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
                var hasApplied = await _context.JobApplications.AnyAsync(ja => ja.JobId == id && ja.CreatedBy == userId);
                var hasSaved = await _context.SavedJobs.AnyAsync(sj => sj.JobId == id && sj.CreatedBy == userId);

                result.IsApplied = hasApplied;
                result.IsSaved = hasSaved;
            }

            return result;
        }

        private static Job MapJob(DbDataReader reader)
        {
            var schemaTable = reader.GetSchemaTable();
            bool columnExists = schemaTable.AsEnumerable()
                                           .Any(row => row.Field<string>("ColumnName") == "NumberOfApplications");
            return new Job
            {
                Id = reader.GetInt32(reader.GetOrdinal("id")),
                Name = reader.GetString(reader.GetOrdinal("name")),
                Description = reader.GetString(reader.GetOrdinal("description")),
                StreetAddressAndNumber = reader.GetString(reader.GetOrdinal("street_address_and_number")),
                State = reader.GetInt32(reader.GetOrdinal("state")),
                CityId = reader.GetInt32(reader.GetOrdinal("city_id")),
                Status = reader.GetInt32(reader.GetOrdinal("status")),
                Created = reader.GetDateTime(reader.GetOrdinal("created")),
                CreatedBy = reader.GetInt32(reader.GetOrdinal("created_by")),
                NumberOfApplications = columnExists ? reader.GetInt32(reader.GetOrdinal("NumberOfApplications")) : 0,
                ApplicationsDuration = reader.IsDBNull(reader.GetOrdinal("applications_duration"))
    ? (int?)null
    : reader.GetInt32(reader.GetOrdinal("applications_duration"))
            };
        }

        public async Task<IEnumerable<Job>> GetEmployerJobsAsync(int employerId)
        {
            var sqlQuery = @"
                SELECT j.*,
                    (
                        SELECT COUNT(*)
                        FROM job_applications AS ja
                        WHERE ja.job_id = j.id AND ja.status != 0
                    ) AS NumberOfApplications
                FROM jobs AS j
                WHERE j.created_by = @employerId;
            ";

            await using var connection = new SqlConnection(_context.Database.GetConnectionString());
            await connection.OpenAsync();

            await using var command = connection.CreateCommand();
            command.CommandText = sqlQuery;
            command.Parameters.Add(new SqlParameter("@employerId", employerId));
            var jobs = new List<Job>();

            await using var reader = await command.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                var job = MapJob(reader);

                jobs.Add(job);
            }
            return jobs;
        }

        public async Task<IEnumerable<Job>> SearchAsync(string searchText, int limit, int offset, int? cityId, int? jobTypeId)
        {
            var sqlQuery = @"
        WITH FilteredJobs AS (
            SELECT j.*,
                (
                    SELECT JSON_QUERY(CAST((SELECT pa.id, pa.answer, pa.question_id 
                                            FROM job_questions AS jq
                                            LEFT JOIN job_question_answers AS qa ON jq.id = qa.job_question_id
                                            LEFT JOIN proposed_answers AS pa ON qa.proposed_answer_id = pa.id
                                            WHERE jq.job_id = j.id AND jq.question_id = 1 FOR JSON PATH) AS NVARCHAR(MAX)))
                ) AS Schedules,
                (
                    SELECT JSON_QUERY(CAST((SELECT pa.id, pa.answer, pa.question_id 
                                            FROM job_questions AS jq
                                            LEFT JOIN job_question_answers AS qa ON jq.id = qa.job_question_id
                                            LEFT JOIN proposed_answers AS pa ON qa.proposed_answer_id = pa.id
                                            WHERE jq.job_id = j.id AND jq.question_id = 2 FOR JSON PATH) AS NVARCHAR(MAX)))
                ) AS PaymentQuestion,
                (
                    SELECT JSON_QUERY(CAST((SELECT pa.id, pa.answer, pa.question_id 
                                            FROM job_questions AS jq
                                            LEFT JOIN job_question_answers AS qa ON jq.id = qa.job_question_id
                                            LEFT JOIN proposed_answers AS pa ON qa.proposed_answer_id = pa.id
                                            WHERE jq.job_id = j.id AND jq.question_id = 3 FOR JSON PATH) AS NVARCHAR(MAX)))
                ) AS AdditionalPaymentOptions,
                (
                    SELECT JSON_QUERY(CAST((SELECT jt.*
                                            FROM job_types AS jt
                                            WHERE jt.id = j.job_type_id FOR JSON PATH) AS NVARCHAR(MAX)))
                ) AS JobType,
                (
                    SELECT JSON_QUERY(CAST((SELECT c.*
                                            FROM cities AS c
                                            WHERE c.id = j.city_id FOR JSON PATH) AS NVARCHAR(MAX)))
                ) AS City
            FROM jobs AS j
            WHERE (@searchText IS NULL OR j.name LIKE '%' + @searchText + '%')
              AND (@cityId IS NULL OR j.city_id = @cityId)
              AND (@jobTypeId IS NULL OR j.job_type_id = @jobTypeId)
        )
        SELECT *
        FROM FilteredJobs
        ORDER BY id
        OFFSET @offset ROWS FETCH NEXT @limit ROWS ONLY;
    ";
            await using var connection = new SqlConnection(_context.Database.GetConnectionString());
            await connection.OpenAsync();

            await using var command = connection.CreateCommand();
            command.CommandText = sqlQuery;
            command.Parameters.Add(new SqlParameter("@searchText", (object)searchText ?? DBNull.Value));
            command.Parameters.Add(new SqlParameter("@cityId", (object)cityId ?? DBNull.Value));
            command.Parameters.Add(new SqlParameter("@jobTypeId", (object)jobTypeId ?? DBNull.Value));
            command.Parameters.Add(new SqlParameter("@limit", limit));
            command.Parameters.Add(new SqlParameter("@offset", offset));

            var jobs = new List<Job>();

            await using var reader = await command.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                var job = MapJob(reader);

                if (!reader.IsDBNull(reader.GetOrdinal("Schedules")))
                {
                    job.Schedules = JsonConvert.DeserializeObject<List<ProposedAnswer>>(reader.GetString(reader.GetOrdinal("Schedules")));
                }
                if (!reader.IsDBNull(reader.GetOrdinal("PaymentQuestion")))
                {
                    var proposedAnswers = JsonConvert.DeserializeObject<List<ProposedAnswer>>(reader.GetString(reader.GetOrdinal("PaymentQuestion")));
                    if (proposedAnswers.Any())
                    {
                        job.PaymentQuestion = proposedAnswers.FirstOrDefault();
                    }
                }
                if (!reader.IsDBNull(reader.GetOrdinal("AdditionalPaymentOptions")))
                {
                    job.AdditionalPaymentOptions = JsonConvert.DeserializeObject<List<ProposedAnswer>>(reader.GetString(reader.GetOrdinal("AdditionalPaymentOptions")));
                }
                if (!reader.IsDBNull(reader.GetOrdinal("JobType")))
                {
                    var types = JsonConvert.DeserializeObject<List<JobType>>(reader.GetString(reader.GetOrdinal("JobType")));
                    job.JobType = types.FirstOrDefault();
                }
                if (!reader.IsDBNull(reader.GetOrdinal("City")))
                {
                    var cities = JsonConvert.DeserializeObject<List<City>>(reader.GetString(reader.GetOrdinal("City")));
                    job.City = cities.FirstOrDefault();
                }

                jobs.Add(job);
            }

            return jobs;
        }

        public async Task<int> SearchCountAsync(string searchText, int? cityId, int? jobTypeId)
        {
            var sqlQuery = @"
        SELECT COUNT(*)
        FROM jobs AS j
        WHERE (@searchText IS NULL OR j.name LIKE '%' + @searchText + '%')
          AND (@cityId IS NULL OR j.city_id = @cityId)
          AND (@jobTypeId IS NULL OR j.job_type_id = @jobTypeId);
    ";
            await using var connection = new SqlConnection(_context.Database.GetConnectionString());
            await connection.OpenAsync();

            await using var command = connection.CreateCommand();
            command.CommandText = sqlQuery;
            command.Parameters.Add(new SqlParameter("@searchText", (object)searchText ?? DBNull.Value));
            command.Parameters.Add(new SqlParameter("@cityId", (object)cityId ?? DBNull.Value));
            command.Parameters.Add(new SqlParameter("@jobTypeId", (object)jobTypeId ?? DBNull.Value));

            var count = (int)await command.ExecuteScalarAsync();
            return count;
        }

        public async Task<IEnumerable<Job>> GetApplicantSavedJobsAsync(int applicantId)
        {
            var query = from j in _context.Jobs
                        join sj in _context.SavedJobs on j.Id equals sj.JobId
                        join c in _context.Cities on j.CityId equals c.Id
                        where sj.CreatedBy == applicantId
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


            return await query.ToListAsync();
        }

        public async Task<IEnumerable<Job>> GetApplicantAppliedJobsAsync(int applicantId)
        {
            var query = from j in _context.Jobs
                        join a in _context.JobApplications on j.Id equals a.JobId
                        join c in _context.Cities on j.CityId equals c.Id
                        where a.CreatedBy == applicantId
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


            return await query.ToListAsync();
        }

        public async Task<IEnumerable<ApplicantDTO>> GetApplicants(int jobId)
        {
            var applicants = from j in _context.Jobs
                             join ja in _context.JobApplications on j.Id equals ja.JobId
                             join a in _context.Applicants on ja.CreatedBy equals a.Id
                             join u in _context.Users on a.Id equals u.Id
                             join c in _context.Cities on u.CityId equals c.Id
                             where j.Id == jobId
                             select new
                             {
                                 Applicant = a,
                                 User = u,
                                 City = c,
                                 ApplicantJobTypes = a.ApplicantJobTypes
                             };

            var applicantDetails = from app in applicants
                                   let ratings = _context.Ratings
                                                        .Where(r => r.RatedUserId == app.Applicant.Id)
                                                        .Select(r => (double)r.Value)
                                                        .ToList()
                                   let finishedJobsCount = (from ja in _context.JobApplications
                                                            join j in _context.Jobs on ja.JobId equals j.Id
                                                            where ja.CreatedBy == app.Applicant.Id && j.Status == (int)JobStatus.Completed
                                                            select ja).Count()
                                   select new ApplicantDTO
                                   {
                                       Id = app.Applicant.Id,
                                       Cv = app.Applicant.Cv,
                                       Experience = app.Applicant.Experience,
                                       Description = app.Applicant.Description,
                                       WageProposal = app.Applicant.WageProposal,
                                       Created = app.Applicant.Created,
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
                                       NumberOfFinishedJobs = finishedJobsCount
                                   };

            var result = await applicantDetails.ToListAsync();
            return result;

        }
    }
}
