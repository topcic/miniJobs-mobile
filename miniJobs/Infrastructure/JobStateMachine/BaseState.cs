using Application.Common.Exceptions;
using Application.Jobs.Models;
using Domain.Enums;
using Infrastructure.Persistence;
using Microsoft.Extensions.DependencyInjection;

namespace Infrastructure.JobStateMachine
{
    public class BaseState(IServiceProvider serviceProvider, ApplicationDbContext context)
    {
        protected readonly IServiceProvider serviceProvider = serviceProvider;
        protected ApplicationDbContext context = context;

        public virtual Task<Job> Insert(JobInsertRequest request)
        {
            throw new UserException("Nije dopušteno");
        }

        public virtual Task<Job> SaveDetails(JobSaveRequest request)
        {
            throw new UserException("Nije dopušteno");
        }

        public virtual Task<Job> SavePaymentDetails(JobSaveRequest request)
        {
            throw new UserException("Nije dopušteno");
        }

        public virtual Task<Job> Activate(int id,int status)
        {
            throw new UserException("Nije dopušteno");
        }

        public virtual Task<Job> Delete(int id)
        {
            throw new UserException("Nije dopušteno");
        }
        public BaseState CreateState(JobState state)
        {
            return state switch
            {
                JobState.Initial => serviceProvider.GetService<InitialJobState>(),
                JobState.JobDetails => serviceProvider.GetService<JobDetailsState>(),
                JobState.JobPaymentDetails => serviceProvider.GetService<PaymentState>(),
                JobState.Active => serviceProvider.GetService<ActiveJobState>(),
                JobState.Inactive => serviceProvider.GetService<ActiveJobState>(),
                _ => throw new UserException("Nije dopušteno"),
            };
        }
       
        public virtual Task<List<string>> AllowedActions()
        {
            return Task.FromResult(new List<string>());
        }
    }
}
