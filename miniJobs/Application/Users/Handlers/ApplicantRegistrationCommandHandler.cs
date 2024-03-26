using System.Transactions;
using Application.Users.Commands;
using Application.Users.Models;
using AutoMapper;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Users.Handlers;

public class ApplicantRegistrationCommandHandler(IUserManagerRepository userManager,
    IApplicantRepository applicantRepository, IMapper mapper) : IRequestHandler<ApplicantRegistrationCommand, UserRegistrationResponse>
{
    private readonly IUserManagerRepository userManager = userManager;
    private readonly IApplicantRepository applicantRepository = applicantRepository;
    private readonly IMapper mapper = mapper;


    public async Task<UserRegistrationResponse> Handle(ApplicantRegistrationCommand command, CancellationToken cancellationToken)
    {
        UserRegistrationResponse response = new();

        using (var ts = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
        {
            var roleId = "Applicant";
            var user = mapper.Map<User>(command.Request);

            await userManager.InsertAsync(user);

            var applicant = new Applicant()
            {
                Id = user.Id
            };
            await applicantRepository.InsertAsync(applicant);

            var role = await userManager.TryFindRoleAsync(roleId);
            await userManager.AssignUserRoleAsync(user, role);

            ts.Complete();
        }
        response.IsRegistered = true;
        return response;
    }
}