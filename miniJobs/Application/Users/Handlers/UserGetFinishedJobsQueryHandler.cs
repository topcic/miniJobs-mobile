using Application.Users.Queries;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Users.Handlers;
public class UserGetFinishedJobsQueryHandler(IUserManagerRepository userRepository) : IRequestHandler<UserGetFinishedJobsQuery, IEnumerable<Job>>
{
    public async Task<IEnumerable<Job>> Handle(UserGetFinishedJobsQuery request, CancellationToken cancellationToken)
    {
        var user = await userRepository.TryFindAsync(request.Id);
        var isApplicant = request.RoleId == "Applicant";
        return await userRepository.GetFinishedJobs(request.Id, isApplicant);
    }
}