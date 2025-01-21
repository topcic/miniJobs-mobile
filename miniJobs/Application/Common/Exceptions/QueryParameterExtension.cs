using Application.Common.Extensions;
using System.ComponentModel.DataAnnotations.Schema;
using System.Reflection;

namespace Application.Common.Exceptions;

public static class QueryParameterExtension
{
    public static T? TryParseParameter<T>(IReadOnlyDictionary<string, string> parameters, string parameterName) where T : struct
    {
        if (parameters != null && parameters.TryGetValue(parameterName, out var value) && !string.IsNullOrWhiteSpace(value))
        {
            try
            {
                if (typeof(T) == typeof(Guid))
                {
                    if (Guid.TryParse(value, out var parsedGuid))
                    {
                        return (T?)Convert.ChangeType(parsedGuid, typeof(T));
                    }
                }
                else
                {
                    return (T?)Convert.ChangeType(value, typeof(T));
                }
            }
            catch
            {
                return null;
            }
        }
        return null;
    }
    public static string TryParseParameter(IReadOnlyDictionary<string, string> parameters, string parameterName)
    {
        if (parameters != null && parameters.TryGetValue(parameterName, out var value) && !string.IsNullOrWhiteSpace(value))
        {
            return value;  // Return the string directly
        }
        return null;
    }
    public static List<T>? TryParseListParameter<T>(IReadOnlyDictionary<string, string> parameters, string parameterName) where T : struct
    {
        if (parameters != null && parameters.TryGetValue(parameterName, out var value) && !string.IsNullOrWhiteSpace(value))
        {
            try
            {
                var items = value.Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                var list = new List<T>();

                foreach (var item in items)
                {
                    if (typeof(T) == typeof(Guid))
                    {
                        if (Guid.TryParse(item, out var parsedGuid))
                        {
                            list.Add((T)Convert.ChangeType(parsedGuid, typeof(T)));
                        }
                        else
                        {
                            return null; // Invalid GUID in list
                        }
                    }
                    else
                    {
                        list.Add((T)Convert.ChangeType(item.Trim(), typeof(T)));
                    }
                }

                return list;
            }
            catch
            {
                return null;
            }
        }
        return null;
    }
    public static string GetMappedColumnName(string? sortBy, params Type[] entityTypes)
    {
        foreach (var entityType in entityTypes)
        {
            var property = entityType.GetProperty(sortBy, BindingFlags.IgnoreCase | BindingFlags.Public | BindingFlags.Instance);

            if (property != null)
            {
                return property.Name;
            }
        }

        ExceptionExtension.Validate("COLUMN_NOT_EXISTS", () => true);
        return null;
    }
}