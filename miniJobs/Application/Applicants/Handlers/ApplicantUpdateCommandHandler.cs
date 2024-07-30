using Application.Applicants.Commands;
using Application.Common.Extensions;
using AutoMapper;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;
using System.Transactions;

namespace Application.Applicants.Handlers;

public class ApplicantUpdateCommandHandler(IMapper mapper, IApplicantRepository applicantRepository, IUserManagerRepository userManager, IApplicantJobTypeRepository applicantJobTypeRepository) : IRequestHandler<ApplicantUpdateCommand, Applicant>
{
    private readonly IMapper mapper = mapper;
    private readonly IApplicantRepository applicantRepository = applicantRepository;
    private readonly IUserManagerRepository userManager = userManager;
    private readonly IApplicantJobTypeRepository applicantJobTypeRepository = applicantJobTypeRepository;


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

        var addedJobTypes = applicantJobTypeRepository.FindAll(applicant.Id);
        var requestJobTypes = command.Request.JobTypes;

        // Ensure addedJobTypeIds is not null and convert it to a list of JobTypeIds
        var addedJobTypeIds = addedJobTypes?.Select(jt => jt.Id).ToList() ?? new List<int>();

        if (!addedJobTypeIds.Any())
        {
            // Add all job types from the request if there are no added job types
            foreach (var jobTypeId in requestJobTypes)
            {
                await applicantJobTypeRepository.InsertAsync(new ApplicantJobType
                {
                    ApplicantId = applicant.Id,
                    JobTypeId = jobTypeId
                });
            }
        }
        else
        {
            // Find job types to be added
            var jobTypesToAdd = requestJobTypes.Except(addedJobTypeIds).ToList();

            // Find job types to be removed
            var jobTypesToRemove = addedJobTypeIds.Except(requestJobTypes).ToList();

            // Delete removed job types
            foreach (var jobTypeId in jobTypesToRemove)
            {
                var jobTypeToRemove = addedJobTypes.FirstOrDefault(jt => jt.Id == jobTypeId);
                if (jobTypeToRemove != null)
                {

                    applicantJobTypeRepository.DeleteAsync(applicant.Id ,jobTypeToRemove.Id);
                }
            }

            // Add new job types
            foreach (var jobTypeId in jobTypesToAdd)
            {
                await applicantJobTypeRepository.InsertAsync(new ApplicantJobType
                {
                    ApplicantId = applicant.Id,
                    JobTypeId = jobTypeId
                });
            }
        }



        await applicantRepository.UpdateAsync(applicant);
        await userManager.UpdateAsync(user);


        ts.Complete();
        return applicant;
    }
}