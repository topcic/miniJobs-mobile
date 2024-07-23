using Application.Common.Extensions;
using Application.Jobs.Commands;
using AutoMapper;
using Domain.Entities;
using Domain.Enums;
using Domain.Interfaces;
using MediatR;
using System.Collections.Generic;
using System.Transactions;

namespace Application.Jobs.Handlers;


public class JobDetailsSaveCommandHandler : IRequestHandler<JobDetailsSaveCommand, Job>
{
    private readonly IJobRepository _jobRepository;
    private readonly IMapper _mapper;
    private readonly IJobQuestionRepository _jobQuestionRepository;
    private readonly IJobQuestionAnswerRepository _jobQuestionAnswerRepository;
    private readonly IJobTypeRepository _jobTypeRepository;   



    public JobDetailsSaveCommandHandler(IJobRepository jobRepository, IMapper mapper, IJobQuestionRepository jobQuestionRepository,
        IJobQuestionAnswerRepository jobQuestionAnswerRepository, IJobTypeRepository jobTypeRepository)
    {
        _jobRepository = jobRepository;
        _mapper = mapper;
        _jobQuestionRepository = jobQuestionRepository;
        _jobQuestionAnswerRepository = jobQuestionAnswerRepository;
        _jobTypeRepository = jobTypeRepository;
    }

    public async Task<Job> Handle(JobDetailsSaveCommand command, CancellationToken cancellationToken)
     
    {
        using var ts = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);
        Job job = await _jobRepository.TryFindAsync(command.Request.Id);
        ExceptionExtension.Validate("JOB_NOT_EXISTS", () => job == null);
        JobType jobType= await _jobTypeRepository.TryFindAsync(command.Request.JobTypeId);
        ExceptionExtension.Validate("JOB_TYPE_NOT_EXISTS", () => jobType == null);

        _mapper.Map(command.Request, job);
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
        job.State = (int)JobState.JobDetails;

        await _jobRepository.UpdateAsync(job);

        var isApplicant = command.RoleId == Roles.Applicant.ToString();
        job = await _jobRepository.GetWithDetailsAsync(job.Id, isApplicant, command.UserId.Value);

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
            await _jobQuestionAnswerRepository.InsertAsync(jobQuestionAnswer);


        }
    }

    async Task deleteJobQuestionAnswer(IEnumerable<JobQuestionAnswer> jobQuestionAnswers, IEnumerable<int> answers, int jobQuestionId)
    {
        foreach (var answear in answers)
        {
            await _jobQuestionAnswerRepository.DeleteAsync(jobQuestionAnswers.First(x=>x.ProposedAnswerId==answear && x.JobQuestionId== jobQuestionId));
        }
    }

    private async Task ProcessJobQuestions(Job job, int questionId, IEnumerable<int> answers)
    {
        JobQuestion jobQuestion;
        jobQuestion = _jobQuestionRepository.Find(x => x.JobId == job.Id && x.QuestionId == questionId).FirstOrDefault();
        if (jobQuestion == null)
        {
            jobQuestion = new JobQuestion
            {
                QuestionId = questionId,
                JobId = job.Id
            };
            await _jobQuestionRepository.InsertAsync(jobQuestion);
        }

        var jobQuestionAnswersOrg = _jobQuestionAnswerRepository.Find(x => x.JobQuestionId == jobQuestion.Id);
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