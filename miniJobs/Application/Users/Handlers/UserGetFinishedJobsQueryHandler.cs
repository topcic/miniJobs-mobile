using Application.Common.Extensions;
using Application.Users.Queries;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Users.Handlers;
    public class UserGetFinishedJobsQueryHandler : IRequestHandler<UserGetFinishedJobsQuery, IEnumerable<Job>>
{
    private readonly IUserManagerRepository userRepository;


    public UserGetFinishedJobsQueryHandler(IUserManagerRepository userRepository)
    {
        this.userRepository = userRepository;
    }


    public async Task<IEnumerable<Job>> Handle(UserGetFinishedJobsQuery request, CancellationToken cancellationToken)
    {

        var user = await userRepository.TryFindAsync(request.Id);
        ExceptionExtension.Validate("USER_NOT_EXISTS", () => user == null);
        var isApplicant = request.RoleId == "Applicant";
        return await userRepository.GetFinishedJobs(request.Id, isApplicant);
    }
}