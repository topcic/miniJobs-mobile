using Application.Users.Queries;
using Domain.Dtos;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Users.Handlers;
public class UserGetFinishedJobsQueryHandler(IUserManagerRepository userRepository) : IRequestHandler<UserGetFinishedJobsQuery, IEnumerable<JobCardDTO>>
{
    public async Task<IEnumerable<JobCardDTO>> Handle(UserGetFinishedJobsQuery request, CancellationToken cancellationToken)
    {
        var user = await userRepository.TryFindAsync(request.Id);
        var isApplicant = user.Role == "Applicant";
        return await userRepository.GetFinishedJobs(request.Id, isApplicant);
    }
}