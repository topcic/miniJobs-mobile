using Application.Jobs.Commands;
using AutoMapper;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;
using System.Transactions;

namespace Application.Jobs.Handlers;


sealed class JobUpdateCommandHandler(IJobRepository jobRepository, IMapper mapper, IJobQuestionRepository jobQuestionRepository,
    IJobQuestionAnswerRepository jobQuestionAnswerRepository, IJobTypeRepository jobTypeRepository) : IRequestHandler<JobUpdateCommand, Job>
{
    public async Task<Job> Handle(JobUpdateCommand command, CancellationToken cancellationToken)
     
    {
        using var ts = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);
        Job job = await jobRepository.TryFindAsync(command.Request.Id);

        JobType jobType;
        if (command.Request.JobTypeId.HasValue)
            jobType = await jobTypeRepository.TryFindAsync(command.Request.JobTypeId.Value);

        mapper.Map(command.Request, job);
        if (command.Request.JobSchedule != null)
        {
            await ProcessJobQuestions(job, command.Request.JobSchedule.QuestionId, command.Request.JobSchedule.Answers);
        }

        // Process AnswersToPaymentQuestions
        if (command.Request.AnswersToPaymentQuestions != null)
        {
            foreach (var kvp in command.Request.AnswersToPaymentQuestions)
            {
                await ProcessJobQuestions(job, kvp.Key, kvp.Value);
            }
        }

        job.LastModified = DateTime.UtcNow;
        job.LastModifiedBy = command.UserId;

        await jobRepository.UpdateAsync(job);

        job = await jobRepository.GetWithDetailsAsync(job.Id, false, command.UserId.Value);

        ts.Complete();

        return job;
    }
    async Task insertJobQuestionAnswer(IEnumerable<int> answers,int jobQuestionId)
    {
        foreach (var answear in answers)
        {
            var jobQuestionAnswer = new JobQuestionAnswer
            {
                JobQuestionId = jobQuestionId,
                ProposedAnswerId = answear
            };
            await jobQuestionAnswerRepository.InsertAsync(jobQuestionAnswer);


        }
    }

    async Task deleteJobQuestionAnswer(IEnumerable<JobQuestionAnswer> jobQuestionAnswers, IEnumerable<int> answers, int jobQuestionId)
    {
        foreach (var answear in answers)
        {
            await jobQuestionAnswerRepository.DeleteAsync(jobQuestionAnswers.First(x=>x.ProposedAnswerId==answear && x.JobQuestionId== jobQuestionId));
        }
    }

    private async Task ProcessJobQuestions(Job job, int questionId, IEnumerable<int> answers)
    {
        JobQuestion jobQuestion;
        jobQuestion = jobQuestionRepository.Find(x => x.JobId == job.Id && x.QuestionId == questionId).FirstOrDefault();
        if (jobQuestion == null)
        {
            jobQuestion = new JobQuestion
            {
                QuestionId = questionId,
                JobId = job.Id
            };
            await jobQuestionRepository.InsertAsync(jobQuestion);
        }

        var jobQuestionAnswersOrg = jobQuestionAnswerRepository.Find(x => x.JobQuestionId == jobQuestion.Id);
        IEnumerable<int> jobQuestionAnswers= new List<int>();
        if (jobQuestionAnswersOrg.Any())
            jobQuestionAnswers = jobQuestionAnswersOrg.Select(x => x.ProposedAnswerId);
        if (jobQuestionAnswers.Any())
        {
            IEnumerable<int> answersForInsert = answers.Except(jobQuestionAnswers);
            IEnumerable<int> answersForDelete = jobQuestionAnswers.Except(answers);
            if (answersForInsert.Any())
                await insertJobQuestionAnswer(answersForInsert, jobQuestion.Id);
            if (answersForDelete.Any())
                await deleteJobQuestionAnswer(jobQuestionAnswersOrg, answersForDelete, jobQuestion.Id);
        }
        else
        {
            await insertJobQuestionAnswer(answers, jobQuestion.Id);
        }
    }
}