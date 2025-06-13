using Application.Common;
using Application.Common.Interfaces;
using Hangfire;
using Infrastructure.Authentication;
using Infrastructure.Common.Interfaces;
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
        services.AddLocalization();
        AddOptionSetups(services);
        AddRepositories(services);
        AddServices(services);
        AddMailSenders(services);

        AddBackgroundJobs(services,configuration);
       
        return services;
    }

    private static void AddBackgroundJobs(IServiceCollection services, IConfiguration configuration)
    {
        string connectionString = configuration.GetConnectionString("DefaultConnectionHangfire");
        services.AddHangfire(config => config.UseSqlServerStorage(connectionString));
        services.AddHangfireServer(options=> options.SchedulePollingInterval=TimeSpan.FromSeconds(1));
    }

    private static void AddRepositories(IServiceCollection services)
    {
        services.AddScoped<IJobRepository, JobRepository>();
        services.AddScoped<IUserManagerRepository, UserManagerRepository>();
        services.AddScoped<IEmployerRepository, EmployerRepository>();
        services.AddScoped<IApplicantRepository, ApplicantRepository>();
        services.AddScoped<IJobApplicationRepository, JobApplicationRepository>();
        services.AddScoped<IJobTypeRepository, JobTypeRepository>();
        services.AddScoped<ISavedJobRepository, SavedJobRepository>();
        services.AddScoped<IRatingRepository, RatingRepository>();
        services.AddScoped<ICityRepository, CityRepository>();
        services.AddScoped<ICountryRepository, CountryRepository>();
        services.AddScoped<IApplicantJobTypeRepository, ApplicantJobTypeRepository>();
        services.AddScoped<IUserAuthCodeRepository, UserAuthCodeRepository>();
        services.AddScoped<ITokenRepository, TokenRepository>();
        services.AddScoped<IQuestionRepository, QuestionRepository>();
        services.AddScoped<IProposedAnswerRepository, ProposedAnswerRepository>();
        services.AddScoped<IJobQuestionRepository, JobQuestionRepository>();
        services.AddScoped<IJobQuestionAnswerRepository, JobQuestionAnswerRepository>();
        services.AddScoped<IJobRecommendationRepository, JobRecommendationRepository>();
        services.AddScoped<IJobRecommendationJobTypeRepository, JobRecommendationJobTypeRepository>();
        services.AddScoped<IJobRecommendationCityRepository, JobRecommendationCityRepository>();
        services.AddScoped<IStatisticRepository, StatisticRepository>();

    }

    private static void AddMailSenders(IServiceCollection services)
    {
        services.AddSingleton<IEmailSender, EmailSender>();
    }

    private static void AddOptionSetups(IServiceCollection services)
    {
        services.ConfigureOptions<JwtOptionsSetup>();
        services.ConfigureOptions<JwtBearerOptionsSetup>();
        services.ConfigureOptions<EmailSenderOptionsSetup>();
        services.ConfigureOptions<MinijobsLocalizationOptionsSetup>();
        services.ConfigureOptions<LocalizationOptionsSetup>();
        services.ConfigureOptions<RequestLocalizationOptionsSetup>();
        services.ConfigureOptions<BackgroundJobServicesOptionsSetup>();
        services.ConfigureOptions<AuthCodeOptionsSetup>();

    }
    private static void AddServices(IServiceCollection services)
    {
        services.AddTransient<IJwtProvider, JwtProvider>();
        services.AddScoped<ISecurityProvider, SecurityProvider>();
        services.AddTransient<IEmailService, EmailService>();
        services.AddSingleton<ILocalizationService, LocalizationService>();
        services.AddScoped<IUnitOfWork, UnitOfWork>();
        services.AddScoped<IRecommendationService, RecommendationService>();
        services.AddTransient<IRabbitMQProducer, RabbitMQProducer>();
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