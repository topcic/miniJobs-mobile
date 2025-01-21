using Application.Common.Exceptions;
using AutoMapper;
using Domain.Dtos;
using Domain.Enums;
using System.Linq.Expressions;

namespace Infrastructure.Persistence.Repositories;

public abstract class GenericRepository<TEntity, T, TContext> : IGenericRepository<TEntity, T>
    where TEntity : class, IEntity<T>, new()
    where T : IComparable, IEquatable<T>
    where TContext : DbContext
{
    private readonly TContext _context;
    protected readonly DbSet<TEntity> DbSet;
    private readonly IMapper _mapper;

    protected TContext Context => _context;

    public GenericRepository(TContext context, IMapper mapper)
    {
        ArgumentNullException.ThrowIfNull(context);
        ArgumentNullException.ThrowIfNull(mapper);

        _context = context;
        DbSet = context.Set<TEntity>();
        _mapper = mapper;
    }

    public virtual async Task<TEntity> TryFindAsync(T id)
    {
        return await DbSet.SingleOrDefaultAsync(x => x.Id.Equals(id));
    }

    public async Task<TEntity> FindOneAsync(Expression<Func<TEntity, bool>> condition)
    {
        return await DbSet.SingleOrDefaultAsync(condition);
    }

    public IEnumerable<TEntity> Find(Expression<Func<TEntity, bool>>? condition = null)
    {
        return condition != null ? DbSet.Where(condition).AsEnumerable() : DbSet.AsEnumerable();
    }

    public async Task InsertAsync(TEntity entity)
    {
        await DbSet.AddAsync(entity);
        await Context.SaveChangesAsync();
    }

    public async Task UpdateAsync(TEntity entity)
    {
        DbSet.Update(entity);
        await Context.SaveChangesAsync();
    }

    public async Task DeleteAsync(TEntity entity)
    {
        DbSet.Remove(entity);
        await Context.SaveChangesAsync();
    }

    public async Task<IEnumerable<TEntity>> FindAllAsync()
    {
        return await DbSet.ToListAsync();
    }

    public virtual async Task<int> CountAsync(Dictionary<string, string> parameters = null)
    {
        var query = DbSet.AsQueryable();

        if (parameters != null && parameters.TryGetValue("searchText", out string searchText))
        {
            query = ApplySearchFilter(query, searchText);
        }

        return await query.CountAsync();
    }

    public virtual async Task<IEnumerable<TEntity>> FindPaginationAsync(Dictionary<string, string> parameters = null)
    {
        var query = DbSet.AsQueryable();
        var queryParameters = _mapper.Map<QueryParametersDto>(parameters);

        if (!string.IsNullOrEmpty(queryParameters.SearchText))
        {
            query = ApplySearchFilter(query, queryParameters.SearchText);
        }

        if (!string.IsNullOrEmpty(queryParameters.SortBy))
        {
            string columnName = QueryParameterExtension.GetMappedColumnName(queryParameters.SortBy, typeof(TEntity));
            query = queryParameters.SortOrder == SortOrder.DESC
                ? query.OrderByDescending(e => EF.Property<object>(e, columnName))
                : query.OrderBy(e => EF.Property<object>(e, columnName));
        }

        query = query.Skip(queryParameters.Offset).Take(queryParameters.Limit);

        return await query.ToListAsync();
    }

    private IQueryable<TEntity> ApplySearchFilter(IQueryable<TEntity> query, string searchText)
    {
        var entityType = typeof(TEntity);
        var stringProperties = entityType.GetProperties()
            .Where(p => p.PropertyType == typeof(string));

        var parameter = Expression.Parameter(entityType, "x");
        Expression predicate = Expression.Constant(false);

        foreach (var property in stringProperties)
        {
            var propertyAccess = Expression.Property(parameter, property);
            var containsMethod = typeof(string).GetMethod("Contains", new[] { typeof(string) });
            var searchExpression = Expression.Call(propertyAccess, containsMethod, Expression.Constant(searchText));
            predicate = Expression.OrElse(predicate, searchExpression);
        }

        var lambda = Expression.Lambda<Func<TEntity, bool>>(predicate, parameter);
        return query.Where(lambda);
    }
}
