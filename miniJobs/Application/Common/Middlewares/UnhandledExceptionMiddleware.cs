

using Application.Common.Exceptions;
using Application.Common.Interfaces;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;

namespace Application.Common.Middlewares;

/// <summary>
/// Unhandled Exception Middleware
/// </summary>
public class UnhandledExceptionMiddleware
{
    private readonly ILogger logger;
    private readonly RequestDelegate next;
    private readonly ILocalizationService localizationService;

    public UnhandledExceptionMiddleware(RequestDelegate next, ILogger<UnhandledExceptionMiddleware> logger, ILocalizationService localizationService)
    {
        this.next = next ?? throw new ArgumentNullException(nameof(next));
        this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
        this.localizationService = localizationService;
    }

    public async Task Invoke(HttpContext context)
    {
        try
        {
            await next.Invoke(context);
        }
        catch (ValidationException vEx)
        {
            logger.LogError(vEx, $"Endpoint: {context.Request.Method}: {context.Request.Path}");
            context.Response.StatusCode = StatusCodes.Status422UnprocessableEntity;

            foreach (var ex in vEx.Errors) //translate validation messages
                for (var i = 0; i < ex.Value.Length; i++)
                    ex.Value[i] = localizationService.GetLocalizedString(ex.Value[i]).Value;

            await context.Response.WriteAsJsonAsync(vEx.Errors);
        }
        catch (Exception ex)
        {
            logger.LogError(ex, $"Endpoint: {context.Request.Method}: {context.Request.Path}");
            context.Response.StatusCode = StatusCodes.Status400BadRequest;
            await context.Response.WriteAsJsonAsync(localizationService.GetLocalizedString(ex.Message).Value);
        }
    }
}