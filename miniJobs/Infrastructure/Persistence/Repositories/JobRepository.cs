using Domain.Entities;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;
using System.Data;
using System.Data.Common;
using System.Runtime.CompilerServices;
using System.Text;

namespace Infrastructure.Persistence.Repositories
{
    public class JobRepository : GenericRepository<Job, int, ApplicationDbContext>, IJobRepository
    {
        private readonly ApplicationDbContext _context;

        public JobRepository(ApplicationDbContext context) : base(context)
        {
            _context = context;
        }

        public async Task<Job> GetWithDetailsAsync(int id)
        {
            var sqlQuery = @"
              WITH SchedulesCTE AS (
    SELECT jq.job_id, pa.*
    FROM job_questions AS jq
    LEFT JOIN job_question_answers AS qa ON jq.id = qa.job_question_id
    LEFT JOIN proposed_answers AS pa ON qa.proposed_answer_id = pa.id
    WHERE jq.question_id = 1
),
PaymentQuestionCTE AS (
    SELECT jq.job_id, pa.*
    FROM job_questions AS jq
    LEFT JOIN job_question_answers AS qa ON jq.id = qa.job_question_id
    LEFT JOIN proposed_answers AS pa ON qa.proposed_answer_id = pa.id
    WHERE jq.question_id = 2
),
AdditionalPaymentOptionsCTE AS (
    SELECT jq.job_id, pa.*
    FROM job_questions AS jq
    LEFT JOIN job_question_answers AS qa ON jq.id = qa.job_question_id
    LEFT JOIN proposed_answers AS pa ON qa.proposed_answer_id = pa.id
    WHERE jq.question_id = 3
),
JobTypeCTE AS (
    SELECT j.id,
           (
               SELECT jt.*
               FROM job_types AS jt
               WHERE jt.id = j.job_type_id
               FOR JSON PATH
           ) AS JobType
    FROM jobs AS j
    WHERE j.id = @JobId
),
CityCTE AS (
    SELECT j.id,
           (
               SELECT c.*
               FROM cities  AS c
               WHERE c.id = j.city_id
               FOR JSON PATH
           ) AS City
    FROM jobs AS j
    WHERE j.id = @JobId
)
SELECT j.*,
    (
        SELECT JSON_QUERY(CAST((SELECT pa.id, pa.answer, pa.question_id FROM SchedulesCTE AS pa WHERE pa.job_id = j.id FOR JSON PATH) AS NVARCHAR(MAX)))
    ) AS Schedules,
    (
        SELECT JSON_QUERY(CAST((SELECT pa.id, pa.answer, pa.question_id FROM PaymentQuestionCTE AS pa WHERE pa.job_id = j.id FOR JSON PATH) AS NVARCHAR(MAX)))
    ) AS PaymentQuestion,
    (
        SELECT JSON_QUERY(CAST((SELECT pa.id, pa.answer, pa.question_id FROM AdditionalPaymentOptionsCTE AS pa WHERE pa.job_id = j.id FOR JSON PATH) AS NVARCHAR(MAX)))
    ) AS AdditionalPaymentOptions,
    jt.JobType AS JobType,c.City as City
FROM jobs AS j
INNER JOIN CityCTE as c ON c.id=j.id
LEFT JOIN JobTypeCTE AS jt ON j.id = jt.id;

            ";

            await using var connection = new SqlConnection(_context.Database.GetConnectionString());
            await connection.OpenAsync();

            await using var command = connection.CreateCommand();
            command.CommandText = sqlQuery;
            command.Parameters.Add(new SqlParameter("@JobId", id));

            await using var reader = await command.ExecuteReaderAsync();
            if (await reader.ReadAsync())
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
                  var types= JsonConvert.DeserializeObject<List<JobType>>(reader.GetString(reader.GetOrdinal("JobType")));
                    job.JobType = types[0];
                }
                if (!reader.IsDBNull(reader.GetOrdinal("City")))
                {
                    var cities = JsonConvert.DeserializeObject<List<City>>(reader.GetString(reader.GetOrdinal("City")));
                    job.City = cities[0];
                }

                return job;
            }

            return null;
        }

        private static Job MapJob(DbDataReader reader)
        {
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
                NumberOfApplications = reader.GetInt32(reader.GetOrdinal("NumberOfApplications")),
            };
        }

        public async Task<IEnumerable<Job>> GetEmployeerJobsAsync(int employeerId)
        {
            var sqlQuery = @"
                SELECT j.*,
                    (
                        SELECT COUNT(*)
                        FROM job_applications AS ja
                        WHERE ja.job_id = j.id AND ja.status != 0
                    ) AS NumberOfApplications
                FROM jobs AS j
                WHERE j.created_by = @employeerId;
            ";

            await using var connection = new SqlConnection(_context.Database.GetConnectionString());
            await connection.OpenAsync();

            await using var command = connection.CreateCommand();
            command.CommandText = sqlQuery;
            command.Parameters.Add(new SqlParameter("@employeerId", employeerId));
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
    }
}
