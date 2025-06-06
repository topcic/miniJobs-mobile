﻿using Application.Jobs.Queries;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Jobs.Handlers;

sealed class JobFindAllForEmployerQueryHandler(IJobRepository jobRepository) : IRequestHandler<JobFindAllForEmployerQuery, IEnumerable<Job>>
{
    public async Task<IEnumerable<Job>> Handle(JobFindAllForEmployerQuery request, CancellationToken cancellationToken)
    {

        return await  jobRepository.GetEmployerJobsAsync(request.EmployerId);
    }
}
