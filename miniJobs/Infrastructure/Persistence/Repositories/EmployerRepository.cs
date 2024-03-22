namespace Infrastructure.Persistence.Repositories;

public class EmployerRepository(ApplicationDbContext context) : GenericRepository<Employer, int, ApplicationDbContext>(context), IEmployerRepository
{
}
