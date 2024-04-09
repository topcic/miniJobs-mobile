using Domain.Entities;
using MediatR;

namespace Application.JobTypes.Queries;

public class JobTypeFindAllQuery : IRequest<IEnumerable<JobType>>
{
}
