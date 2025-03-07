using Application.Common.Exceptions;
using AutoMapper;
using Domain.Dtos;


namespace Infrastructure.Persistence.Repositories;

public class RatingRepository(ApplicationDbContext context, IMapper mapper) : GenericRepository<Rating, int, ApplicationDbContext>(context, mapper), IRatingRepository
{
    public async Task<IEnumerable<Rating>> GetRatingsForReportsAsync()
    {
        var ratings = from r in context.Ratings
                      join createdByUser in context.Users on r.CreatedBy equals createdByUser.Id into createdByUserGroup
                      from createdByUser in createdByUserGroup.DefaultIfEmpty()
                      join ratedUser in context.Users on r.RatedUserId equals ratedUser.Id into ratedUserGroup
                      from ratedUser in ratedUserGroup.DefaultIfEmpty()
                      join createdByUserRole in context.UserRoles on createdByUser.Id equals createdByUserRole.UserId into createdByUserRoleGroup
                      from createdByUserRole in createdByUserRoleGroup.DefaultIfEmpty()
                      join ratedUserRole in context.UserRoles on ratedUser.Id equals ratedUserRole.UserId into ratedUserRoleGroup
                      from ratedUserRole in ratedUserRoleGroup.DefaultIfEmpty()
                      select new Rating
                      {
                          Id = r.Id,
                          Value = r.Value,
                          Comment = r.Comment,
                          JobApplicationId = r.JobApplicationId,
                          RatedUserId = r.RatedUserId,
                          IsActive = r.IsActive,
                          CreatedByFullName = createdByUser != null ? createdByUser.FirstName + " " + createdByUser.LastName : null,
                          RatedUserFullName = ratedUser != null ? ratedUser.FirstName + " " + ratedUser.LastName : null,
                          CreatedByRole = createdByUserRole != null ? createdByUserRole.RoleId : null,
                          RatedUserRole = ratedUserRole != null ? ratedUserRole.RoleId : null,
                          Created = r.Created,
                          CreatedBy = r.CreatedBy,
                          LastModified = r.LastModified,
                          LastModifiedBy = r.LastModifiedBy
                      };

        return await ratings.ToListAsync();
    }

    public async override Task<int> CountAsync(Dictionary<string, string> parameters = null)
    {

        var query = context.Ratings.AsQueryable();

        if (parameters != null && parameters.TryGetValue("searchText", out string searchText) && !string.IsNullOrWhiteSpace(searchText))
        {
            query = query.Where(r =>
               (r.Value.ToString().Contains(searchText)) ||
               (r.Comment.Contains(searchText))
           );
        }


        var count = await query.CountAsync();
        return count;
    }
    public async override Task<IEnumerable<Rating>> FindPaginationAsync(Dictionary<string, string> parameters = null)
    {
        var queryParameters = mapper.Map<QueryParametersDto>(parameters);

        // Base query
        var query = from r in context.Ratings
                    join createdByUser in context.Users on r.CreatedBy equals createdByUser.Id into createdByUserGroup
                    from createdByUser in createdByUserGroup.DefaultIfEmpty()
                    join ratedUser in context.Users on r.RatedUserId equals ratedUser.Id into ratedUserGroup
                    from ratedUser in ratedUserGroup.DefaultIfEmpty()
                    join createdByEmployer in context.Employers on r.CreatedBy equals createdByEmployer.Id into createdByEmployerGroup
                    from createdByEmployer in createdByEmployerGroup.DefaultIfEmpty()
                    join ratedUserEmployer in context.Employers on r.RatedUserId equals ratedUserEmployer.Id into ratedUserEmployerGroup
                    from ratedUserEmployer in ratedUserEmployerGroup.DefaultIfEmpty()
                    join ja in context.JobApplications on r.JobApplicationId equals ja.Id into jobApplicationGroup
                    from ja in jobApplicationGroup.DefaultIfEmpty()
                    join j in context.Jobs on ja.JobId equals j.Id into jobGroup
                    from j in jobGroup.DefaultIfEmpty()
                    join createdByUserRole in context.UserRoles on r.CreatedBy equals createdByUserRole.UserId into createdByUserRoleGroup
                    from createdByUserRole in createdByUserRoleGroup.DefaultIfEmpty()
                    join ratedUserRole in context.UserRoles on r.RatedUserId equals ratedUserRole.UserId into ratedUserRoleGroup
                    from ratedUserRole in ratedUserRoleGroup.DefaultIfEmpty()
                    join createdByRole in context.Roles on createdByUserRole.RoleId equals createdByRole.Id into createdByRoleGroup
                    from createdByRole in createdByRoleGroup.DefaultIfEmpty()
                    join ratedUserRoleEntity in context.Roles on ratedUserRole.RoleId equals ratedUserRoleEntity.Id into ratedUserRoleEntityGroup
                    from ratedUserRoleEntity in ratedUserRoleEntityGroup.DefaultIfEmpty()
                    select new Rating
                    {
                        Id = r.Id,
                        Value = r.Value,
                        Comment = r.Comment,
                        JobApplicationId = r.JobApplicationId,
                        RatedUserId = r.RatedUserId,
                        IsActive = r.IsActive,
                        CreatedByFullName = createdByEmployer != null && !string.IsNullOrEmpty(createdByEmployer.Name)
                            ? createdByEmployer.Name
                            : (createdByUser != null ? createdByUser.FirstName + " " + createdByUser.LastName : null),
                        RatedUserFullName = ratedUserEmployer != null && !string.IsNullOrEmpty(ratedUserEmployer.Name)
                            ? ratedUserEmployer.Name
                            : (ratedUser != null ? ratedUser.FirstName + " " + ratedUser.LastName : null),
                        Created = r.Created,
                        CreatedBy = r.CreatedBy,
                        LastModified = r.LastModified,
                        LastModifiedBy = r.LastModifiedBy,
                        JobName = j != null ? j.Name : null,
                        CreatedByRole = createdByRole != null ? createdByRole.Id : null,
                        RatedUserRole = ratedUserRoleEntity != null ? ratedUserRoleEntity.Id : null
                    };


        // Filtering by search text
        if (!string.IsNullOrEmpty(queryParameters.SearchText))
        {
            query = query.Where(r => r.Comment.Contains(queryParameters.SearchText) || r.Value.ToString().Contains(queryParameters.SearchText));
        }

        // Sorting
        if (!string.IsNullOrEmpty(queryParameters.SortBy))
        {
            string columnName = QueryParameterExtension.GetMappedColumnName(queryParameters.SortBy, typeof(Rating));
            query = queryParameters.SortOrder == Domain.Enums.SortOrder.DESC
                ? query.OrderByDescending(r => EF.Property<object>(r, columnName))
                : query.OrderBy(r => EF.Property<object>(r, columnName));
        }

        // Pagination
        query = query.Skip(queryParameters.Offset).Take(queryParameters.Limit);

        return await query.ToListAsync();
    }

}