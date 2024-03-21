using FluentValidation.AspNetCore;
using Microsoft.AspNetCore.Mvc;
using Microsoft.OpenApi.Models;


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
    public static IServiceCollection AddWebAPIServices(this IServiceCollection services, IConfiguration configuration)
    {
        services.AddFluentValidationAutoValidation().AddFluentValidationClientsideAdapters();
        // Customise default API behaviour options
        services.Configure<ApiBehaviorOptions>(options => options.SuppressModelStateInvalidFilter = true);

        services.AddSwaggerGen(options =>
        {
            options.SwaggerDoc("v1", new OpenApiInfo
            {
                Version = "v1",
                Title = "miniJobs API",
            });
        });

        services.AddCors(options =>
        {
            // this defines a CORS policy called "default"
            options.AddPolicy("miniJobsCors", policy =>
            {
                policy
                    .AllowAnyHeader()
                    .AllowAnyMethod()
                    .SetIsOriginAllowed((host) => true)
                    .AllowCredentials();

            });
        });

        services.AddControllers().AddNewtonsoftJson(x => x.SerializerSettings.ReferenceLoopHandling = Newtonsoft.Json.ReferenceLoopHandling.Ignore);

        return services;
    }
}