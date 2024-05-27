using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Newtonsoft.Json;
using System.Data.Common;
using System.Runtime.CompilerServices;

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
                )
                SELECT j.*,
                    (
                        SELECT pa.id, pa.answer, pa.question_id
                        FROM SchedulesCTE AS pa
                        WHERE pa.job_id = j.id
                        FOR JSON PATH
                    ) AS Schedules,
                    (
                        SELECT pa.id, pa.answer, pa.question_id
                        FROM PaymentQuestionCTE AS pa
                        WHERE pa.job_id = j.id
                        FOR JSON PATH
                    ) AS PaymentQuestion,
                        (
                        SELECT pa.id, pa.answer, pa.question_id
                        FROM AdditionalPaymentOptionsCTE AS pa
                        WHERE pa.job_id = j.id
                        FOR JSON PATH
                    ) AS AdditionalPaymentOptions
                FROM jobs AS j
                WHERE j.id = @JobId;
            ";

            await using var connection = _context.Database.GetDbConnection();
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
            };
        }

        public async Task<IEnumerable<Job>> GetEmployeerJobsAsync(int employeerId)
        {
            var sqlQuery = FormattableStringFactory.Create(@"
    SELECT j.*,
        (
            SELECT COUNT(*)
            FROM job_applications AS ja
            WHERE ja.job_id = j.id AND ja.status != 0
        ) AS NumberOfApplications
    FROM jobs AS j
    WHERE j.created_by = {0};
", employeerId);
            var jobs = await _context.Database
             .SqlQuery<Job>(sqlQuery).ToListAsync();

            return jobs;
        }
    }
}
