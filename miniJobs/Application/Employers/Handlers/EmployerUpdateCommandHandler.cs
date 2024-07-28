using Application.Common.Extensions;
using Application.Employers.Commands;
using AutoMapper;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;
using System.Transactions;

namespace Application.Employers.Handlers;

public class EmployerUpdateCommandHandler(IMapper mapper, IEmployerRepository employerRepository, IUserManagerRepository userManager) : IRequestHandler<EmployerUpdateCommand, Employer>
{
    private readonly IMapper mapper = mapper;
    private readonly IEmployerRepository employerRepository = employerRepository;
    private readonly IUserManagerRepository userManager = userManager;



    public async Task<Employer> Handle(EmployerUpdateCommand command, CancellationToken cancellationToken)
    {
        using var ts = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);
        var employer = await employerRepository.TryFindAsync(command.EmployerId);
        ExceptionExtension.Validate("EMPOLOYER_NOT_EXISTS", () => employer == null);
        var user = await userManager.TryFindAsync(command.EmployerId);

        mapper.Map(command.Request, user);
        mapper.Map(command.Request, employer);

        await employerRepository.UpdateAsync(employer);
        await userManager.UpdateAsync(user);


        ts.Complete();
        return employer;
    }
}
