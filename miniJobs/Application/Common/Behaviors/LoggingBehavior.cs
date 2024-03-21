using MediatR.Pipeline;
using Microsoft.Extensions.Logging;

namespace Application.Common.Behaviours;

public class LoggingBehavior<TRequest> : IRequestPreProcessor<TRequest> where TRequest : notnull
{
    private readonly ILogger _logger;

    public LoggingBehavior(ILogger<TRequest> logger)
    {
        _logger = logger;
    }

    public async Task Process(TRequest request, CancellationToken cancellationToken)
    {
        var requestName = typeof(TRequest).Name;
        //var userId = _currentUserService.UserId ?? string.Empty;
        //string? userName = string.Empty;

        //if (!string.IsNullOrEmpty(userId))
        //{
        //    userName = await _identityService.GetUserNameAsync(userId);
        //}
        //Check with cache

        _logger.LogInformation("miniJobs Request: {Name} {@Request}", requestName, request);
    }
}