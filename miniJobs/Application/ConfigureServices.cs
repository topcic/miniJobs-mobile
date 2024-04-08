using System.Reflection;
using Application.Common.Behaviors;
using Application.Tokens.Commands;
using Application.Tokens.Models;
using Application.Users.Commands;
using Application.Users.Handlers;
using Application.Users.Models;
using FluentValidation;
using MediatR;

namespace Microsoft.Extensions.DependencyInjection;

/// <summary>
/// Configure service
/// </summary>
public static class ConfigureServices
{
    /// <summary>
    /// Add services from application layer
    /// </summary>
    /// <param name="services"></param>
    /// <returns></returns>
    public static IServiceCollection AddApplicationServices(this IServiceCollection services)
    {
        services.AddAutoMapper(Assembly.GetExecutingAssembly());
        services.AddValidatorsFromAssembly(Assembly.GetExecutingAssembly());
        services.AddMediatR(cfg => cfg.RegisterServicesFromAssembly(Assembly.GetExecutingAssembly()));
        services.AddTransient(typeof(IPipelineBehavior<,>), typeof(ValidationBehavior<,>));
        AddHandlers(services);

        return services;
    }
    private static void AddHandlers(IServiceCollection services)
    {
        //Auth tokens related handlers
        services.AddScoped<IRequestHandler<AuthTokenCommand, AuthTokenResponse>, AuthTokenHandler>();//ApplicantRegistrationCommandHandler

        //User related handlers
        services.AddScoped<IRequestHandler<RegistrationCommand, UserRegistrationResponse>, RegistrationCommandHandler>();
    }
}
