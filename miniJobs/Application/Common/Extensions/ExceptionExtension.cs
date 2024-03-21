namespace Application.Common.Extensions;

/// <summary>
/// Provides exception message formatted for APIs response.<see cref='ExceptionExtension'/>
/// </summary>
public static class ExceptionExtension
{
    public static string GetInnerMessage(this Exception ex)
    {
        var inner = ex;

        while (inner.InnerException != null)
        {
            inner = inner.InnerException;
        }

        return inner.Message;
    }

    public static string[] GetAllExceptionMessages(this Exception ex)
    {
        List<string> messages = new();
        messages.Add(ex.Message);

        var inner = ex;

        while (inner.InnerException != null)
        {
            inner = inner.InnerException;
            messages.Add(inner.Message);
        }

        return messages.ToArray();
    }
    public static object GetErrorResponse(this Exception ex, bool isDebug = false)
    {
        string formattedMessage = ex.Message.TrimStart('\"').TrimEnd('\"');
        return isDebug ? ex.GetBaseException() : formattedMessage;
    }

    /// <summary>
    /// If condition is true then throw exception. If action is passed, then execute action before proceeding with exception.
    /// </summary>
    /// <param name="message">ArgumentException Exception message</param>
    /// <param name="condition">condition when to throw exception</param>
    /// <param name="actualValue">Actual value was</param>
    /// <param name="expectedValue">Expected value</param>
    /// <param name="action">action to execute before exception</param>
    public static void Validate(string message, Func<bool> condition, string actualValue = null, string expectedValue = null, Action action = null)
    {
        if (condition())
        {
            if (action != null)
            {
                action();
            }
            if (expectedValue is not null && actualValue is not null)
            {
                throw new ArgumentException(message, $"Expected value: {expectedValue}, but actual value is: {actualValue}");
            }
            else if (actualValue is not null)
            {
                throw new ArgumentException(message, $"Actual value is: {actualValue}");
            }
            else
            {
                throw new ArgumentException(message);
            }
        }
    }
}