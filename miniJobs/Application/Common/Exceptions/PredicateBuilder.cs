using System.Linq.Expressions;

namespace Application.Common.Exceptions;

public static class PredicateBuilder
{
    public static Expression<Func<T, bool>> False<T>() => f => false;

    public static Expression<Func<T, bool>> Or<T>(this Expression<Func<T, bool>> expr1, Expression<Func<T, bool>> expr2)
    {
        var invokedExpr = Expression.Invoke(expr2, expr1.Parameters);
        return Expression.Lambda<Func<T, bool>>(Expression.OrElse(expr1.Body, invokedExpr), expr1.Parameters);
    }
}
