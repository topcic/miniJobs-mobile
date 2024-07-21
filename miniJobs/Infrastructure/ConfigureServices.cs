using Application.Common.Interfaces;
using Infrastructure.Authentication;
using Infrastructure.Common.Interfaces;
using Infrastructure.JobStateMachine;
using Infrastructure.MailSenders;
using Infrastructure.OptionsSetup;
using Infrastructure.Persistence;
using Infrastructure.Persistence.Repositories;
using Infrastructure.Services;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace Microsoft.Extensions.DependencyInjection;

/// <summary>
/// Configure service
/// </summary>
public static class ConfigureServices
{
    /// <summary>
    /// Adds the infrastructure services.
    /// </summary>
    /// <param name="services">The services.</param>
    /// <param name="configuration"></param>
    /// <returns>IServiceCollection.</returns>
    public static IServiceCollection AddInfrastructureServices(this IServiceCollection services, IConfiguration configuration)
    {
        services.AddDbContext<ApplicationDbContext>(options =>
           options.UseSqlServer(configuration.GetConnectionString("DefaultConnection"),
               builder => builder.MigrationsAssembly(typeof(ApplicationDbContext).Assembly.FullName)));

        services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme).AddJwtBearer();

        AddOptionSetups(services);
        AddRepositories(services);
        AddServices(services);

        return services;
    }
    private static void AddRepositories(IServiceCollection services)
    {
        services.AddScoped<IJobRepository, JobRepository>();
        services.AddScoped<ICantonRepository, CantonRepository>();
        services.AddScoped<IUserManagerRepository, UserManagerRepository>();
        services.AddScoped<IEmployerRepository, EmployerRepository>();
        services.AddScoped<IApplicantRepository, ApplicantRepository>();
        services.AddScoped<IJobApplicationRepository, JobApplicationRepository>();
        services.AddScoped<IJobTypeRepository, JobTypeRepository>();
        services.AddScoped<ISavedJobRepository, SavedJobRepository>();
        services.AddScoped<IRatingRepository, RatingRepository>();
        services.AddScoped<ICityRepository, CityRepository>();
        services.AddScoped<ICountryRepository, CountryRepository>();
        services.AddScoped<IMessageRepository, MessageRepository>();
        services.AddScoped<IQuestionThreadRepository, QuestionThreadRepository>(); 
        services.AddScoped<IApplicantJobTypeRepository, ApplicantJobTypeRepository>();
        services.AddScoped<IUserAuthCodeRepository, UserAuthCodeRepository>();
        services.AddScoped<ITokenRepository, TokenRepository>();
        services.AddScoped<IQuestionRepository, QuestionRepository>();
        services.AddScoped<IProposedAnswerRepository, ProposedAnswerRepository>();
        services.AddScoped<IJobQuestionRepository, JobQuestionRepository>();
        services.AddScoped<IJobQuestionAnswerRepository, JobQuestionAnswerRepository>();


    }
    private static void AddOptionSetups(IServiceCollection services)
    {
        services.ConfigureOptions<JwtOptionsSetup>();
        services.ConfigureOptions<JwtBearerOptionsSetup>();
        services.ConfigureOptions<EmailSenderOptionsSetup>();
    }
    private static void AddServices(IServiceCollection services)
    {
        services.AddTransient<IJwtProvider, JwtProvider>();
        services.AddScoped<ISecurityProvider, SecurityProvider>();
        services.AddTransient<IEmailService, EmailService>();
        services.AddTransient<IEmailSender, EmailSender>();
        services.AddTransient<BaseState>();
        services.AddTransient<InitialJobState>();
        services.AddTransient<JobDetailsState>();
        services.AddTransient<PaymentState>();
        services.AddTransient<ActiveJobState>();
    }

    public static void ExecuteMigrations(this WebApplication webApplication)
    {
        try
        {
            using (var scope = webApplication.Services.CreateScope())
            {
                var services = scope.ServiceProvider;

                var context = services.GetRequiredService<ApplicationDbContext>();
                context.Database.Migrate();
            }
        }
        catch (Exception ex)
        {
            webApplication.Logger.LogError(ex, "Execute migrations fail");
        }
    }
}