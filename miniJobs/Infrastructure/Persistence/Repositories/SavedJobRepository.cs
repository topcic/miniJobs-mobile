using Application.Common.Exceptions;
using AutoMapper;
using Domain.Dtos;

namespace Infrastructure.Persistence.Repositories;

public class SavedJobRepository(ApplicationDbContext context, IMapper mapper) : GenericRepository<SavedJob, int, ApplicationDbContext>(context, mapper), ISavedJobRepository
{
    public async override Task<int> CountAsync(Dictionary<string, string> parameters = null)
    {
        var query = context.SavedJobs.AsQueryable();

        if (parameters != null && parameters.TryGetValue("searchText", out string searchText) && !string.IsNullOrWhiteSpace(searchText))
        {
            query = query.Where(sj => sj.Id.ToString().Contains(searchText));
        }

        return await query.CountAsync();
    }

    public async override Task<IEnumerable<SavedJob>> FindPaginationAsync(Dictionary<string, string> parameters = null)
    {
        var queryParameters = mapper.Map<QueryParametersDto>(parameters);

        var query = from sj in context.SavedJobs
                    join createdByUser in context.Users on sj.CreatedBy equals createdByUser.Id into createdByUserGroup
                    from createdByUser in createdByUserGroup.DefaultIfEmpty()
                    join job in context.Jobs on sj.JobId equals job.Id into jobGroup
                    from job in jobGroup.DefaultIfEmpty()
                    select new SavedJob
                    {
                        Id = sj.Id,
                        JobId = sj.JobId,
                        IsDeleted = sj.IsDeleted,
                        JobName = job != null ? job.Name : null,
                        ApplicantFullName = createdByUser != null ? createdByUser.FirstName + " " + createdByUser.LastName : null,
                        Created = sj.Created,
                        CreatedBy = sj.CreatedBy,
                        LastModified = sj.LastModified,
                        LastModifiedBy = sj.LastModifiedBy
                    };

        if (!string.IsNullOrEmpty(queryParameters.SearchText))
        {
            query = query.Where(sj => sj.JobName.Contains(queryParameters.SearchText) || sj.ApplicantFullName.Contains(queryParameters.SearchText));
        }

        if (!string.IsNullOrEmpty(queryParameters.SortBy))
        {
            string columnName = QueryParameterExtension.GetMappedColumnName(queryParameters.SortBy, typeof(SavedJob));
            query = queryParameters.SortOrder == Domain.Enums.SortOrder.DESC
                ? query.OrderByDescending(sj => EF.Property<object>(sj, columnName))
                : query.OrderBy(sj => EF.Property<object>(sj, columnName));
        }

        query = query.Skip(queryParameters.Offset).Take(queryParameters.Limit);

        return await query.ToListAsync();
    }

}