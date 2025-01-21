using Application.Common.Exceptions;
using AutoMapper;
using Domain.Dtos;
using Domain.Enums;
using Domain.Interfaces;
using Microsoft.EntityFrameworkCore;
using System.Linq.Expressions;

namespace Infrastructure.Persistence.Repositories;

public class RepositoryBase<T>(ApplicationDbContext context,IMapper mapper) : IRepositoryBase<T> where T : class, IEntity<int>
{
    protected ApplicationDbContext _context = context;
    
    protected readonly DbSet<T> _dbSet;



    public async Task<IEnumerable<T>> FindAllAsync()
    {
        return await _dbSet.ToListAsync();
    }

    public async Task<T> TryFindAsync(int id)
    {
        var entity = await _dbSet.FindAsync(id);
        return entity;
    }

    public async Task InsertAsync(T entity)
    {
        await _dbSet.AddAsync(entity);
        await _context.SaveChangesAsync();
    }

    public async Task UpdateAsync(T entity)
    {
        _dbSet.Update(entity);
        await _context.SaveChangesAsync();
    }

    public async Task DeleteAsync(int id)
    {
        var entity = await TryFindAsync(id); 
        _dbSet.Remove(entity);
        await _context.SaveChangesAsync();
    }

    public IEnumerable<T> Find(Expression<Func<T, bool>> predicate)
    {
        return _dbSet.Where(predicate).AsEnumerable();
    }

    public async Task<T> FindOneAsync(Expression<Func<T, bool>> predicate)
    {
        return await _dbSet.SingleOrDefaultAsync(predicate);
    }

    public async Task<int> CountAsync(Dictionary<string, string> parameters = null)
    {
        var query = _dbSet.AsQueryable();

        if (parameters != null && parameters.TryGetValue("SearchText", out string searchText))
        {
            query = ApplySearchFilter(query, searchText);
        }

        return await query.CountAsync();
    }

    public async Task<IEnumerable<T>> FindPaginationAsync(Dictionary<string, string> parameters = null)
    {
        var query = _dbSet.AsQueryable();
        var queryParameters = mapper.Map<QueryParametersDto>(parameters);

        if (!string.IsNullOrEmpty(queryParameters.SearchText))
        {
            query = ApplySearchFilter(query, queryParameters.SearchText);
        }

        if (!string.IsNullOrEmpty(queryParameters.SortBy))
        {
            string columnName = QueryParameterExtension.GetMappedColumnName(queryParameters.SortBy, typeof(T));
            query = queryParameters.SortOrder == SortOrder.DESC
                ? query.OrderByDescending(e => EF.Property<object>(e, columnName))
                : query.OrderBy(e => EF.Property<object>(e, columnName));
        }

        query = query.Skip(queryParameters.Offset).Take(queryParameters.Limit);

        return await query.ToListAsync();
    }

    private IQueryable<T> ApplySearchFilter(IQueryable<T> query, string searchText)
    {
        var entityType = typeof(T);
        var stringProperties = entityType.GetProperties()
            .Where(p => p.PropertyType == typeof(string));

        var predicate = PredicateBuilder.False<T>();
        foreach (var property in stringProperties)
        {
            var parameter = Expression.Parameter(entityType, "x");
            var propertyAccess = Expression.Property(parameter, property);
            var containsMethod = typeof(string).GetMethod("Contains", new[] { typeof(string) });
            var searchExpression = Expression.Call(propertyAccess, containsMethod, Expression.Constant(searchText));
            var lambda = Expression.Lambda<Func<T, bool>>(searchExpression, parameter);
            predicate = predicate.Or(lambda);
        }

        return query.Where(predicate);
    }
}