using Domain.Interfaces;
using Infrastructure.Persistence;
using Infrastructure.Persistence.Repositories;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;

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

        AddRepositories(services);

        return services;
    }
    private static void AddRepositories(IServiceCollection services)
    {
        services.AddScoped<IJobRepository, JobRepository>();
        services.AddScoped<ICantonRepository, CantonRepository>();
        services.AddScoped<IUserRepository, UserRepository>();
        services.AddScoped<IApplicantRepository, ApplicantRepository>();
        services.AddScoped<IEmployerRepository, EmployerRepository>();
        services.AddScoped<IJobApplicationRepository, JobApplicationRepository>();
        services.AddScoped<IJobTypeRepository, JobTypeRepository>();
        services.AddScoped<ISavedJobRepository, SavedJobRepository>();
        services.AddScoped<IRatingRepository, RatingRepository>();
        services.AddScoped<ICityRepository, CityRepository>();
        services.AddScoped<ICountryRepository, CountryRepository>();
        services.AddScoped<IMessageRepository, MessageRepository>();
        services.AddScoped<IQuestionThreadRepository, QuestionThreadRepository>(); 
        services.AddScoped<IJobTypeAssignmentRepository, JobTypeAssignmentRepository>();
        services.AddScoped<IApplicantJobTypeRepository, ApplicantJobTypeRepository>();
    }
}