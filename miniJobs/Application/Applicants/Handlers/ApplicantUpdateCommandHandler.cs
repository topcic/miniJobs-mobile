using Application.Applicants.Commands;
using Application.Common.Extensions;
using AutoMapper;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;
using System.Transactions;

namespace Application.Applicants.Handlers;

public class ApplicantUpdateCommandHandler(IMapper mapper, IApplicantRepository applicantRepository, IUserManagerRepository userManager) : IRequestHandler<ApplicantUpdateCommand, Applicant>
{
    private readonly IMapper mapper = mapper;
    private readonly IApplicantRepository applicantRepository = applicantRepository;
    private readonly IUserManagerRepository userManager = userManager;

    public async Task<Applicant> Handle(ApplicantUpdateCommand command, CancellationToken cancellationToken)
    {
        using var ts = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);
        var applicant = await applicantRepository.TryFindAsync(command.ApplicantId);
        ExceptionExtension.Validate("APPLICANT_NOT_EXISTS", () => applicant == null);
        var user = await userManager.TryFindAsync(command.ApplicantId);

        mapper.Map(command.Request, user);
        mapper.Map(command.Request, applicant);

        if (command.Request.CvFile != null)
        {
            var ms = new MemoryStream();
            await command.Request.CvFile.OpenReadStream().CopyToAsync(ms, cancellationToken);
            applicant.Cv = ms.ToArray();
        }
        else
            applicant.Cv = null;
        await applicantRepository.UpdateAsync(applicant);
        await userManager.UpdateAsync(user);


        ts.Complete();
        return applicant;
    }
}