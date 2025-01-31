using AutoMapper;

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
}
