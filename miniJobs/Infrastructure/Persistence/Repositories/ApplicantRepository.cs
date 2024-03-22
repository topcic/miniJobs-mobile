namespace Infrastructure.Persistence.Repositories;

public class ApplicantRepository(ApplicationDbContext context) : GenericRepository<Applicant, int, ApplicationDbContext>(context), IApplicantRepository
{
}