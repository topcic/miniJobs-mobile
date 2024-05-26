using Data.Entities;
using System.Reflection;

namespace Infrastructure.Persistence;

public class ApplicationDbContext : DbContext
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options) { }

    public DbSet<Job> Jobs => Set<Job>();
    public DbSet<City> Cities => Set<City>();
    public DbSet<Country> Countries => Set<Country>();
    public DbSet<RefreshToken> RefreshTokens => Set<RefreshToken>();
    public DbSet<Applicant> Applicants => Set<Applicant>();
    public DbSet<Employer> Employers => Set<Employer>();
    public DbSet<ApplicantJobType> ApplicantJobTypes => Set<ApplicantJobType>();
    public DbSet<Canton> Cantons => Set<Canton>();
    public DbSet<JobApplication> JobApplications => Set<JobApplication>();
    public DbSet<JobType> JobTypes => Set<JobType>();
    public DbSet<Message> Messages => Set<Message>();
    public DbSet<QuestionThread> QuestionThreads => Set<QuestionThread>();
    public DbSet<Rating> Ratings => Set<Rating>();
    public DbSet<Role> Roles => Set<Role>();
    public DbSet<SavedJob> SavedJobs => Set<SavedJob>();
    public DbSet<UserRole> UserRoles => Set<UserRole>();
    public DbSet<User> Users => Set<User>();
    public DbSet<UserAuthCode> UserAuthCodes => Set<UserAuthCode>();
    public DbSet<ProposedAnswer> ProposedAnswers => Set<ProposedAnswer>();
    public DbSet<Question> Questions => Set<Question>();
    public DbSet<JobQuestionAnswer> JobQuestionAnswers => Set<JobQuestionAnswer>();
    public DbSet<JobQuestion> JobQuestions => Set<JobQuestion>();


    protected override void OnModelCreating(ModelBuilder builder)
    {
        builder.ApplyConfigurationsFromAssembly(Assembly.GetExecutingAssembly());

        base.OnModelCreating(builder);
    }
}