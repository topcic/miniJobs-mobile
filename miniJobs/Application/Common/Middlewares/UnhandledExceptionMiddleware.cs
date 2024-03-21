

using Application.Common.Exceptions;
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

    /// <summary>
    /// Initializes a new instance of the <see cref = "UnhandledExceptionMiddleware" /> middleware. 
    /// </summary>
    /// <param name="next">Next action</param>
    /// <param name="logger">The logger</param>
    /// <exception cref="ArgumentNullException"></exception>
    public UnhandledExceptionMiddleware(RequestDelegate next, ILogger<UnhandledExceptionMiddleware> logger)
    {
        this.next = next ?? throw new ArgumentNullException(nameof(next));
        this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
    }

    /// <summary>
    /// Catch unhandled exception and format response (Internal server error with details)
    /// </summary>
    /// <param name="context">Http context</param>
    /// <returns></returns>
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

            await context.Response.WriteAsJsonAsync(vEx.Errors);
        }
        catch (Exception ex)
        {
            logger.LogError(ex, $"Endpoint: {context.Request.Method}: {context.Request.Path}");
            context.Response.StatusCode = StatusCodes.Status400BadRequest;
            await context.Response.WriteAsJsonAsync(ex.Message);
        }
    }
}