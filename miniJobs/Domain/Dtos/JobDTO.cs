using Domain.Enums;

namespace Domain.Dtos;

public class JobDTO
{
    public int Id { get; set; }

    public string Name { get; set; }

    public string Description { get; set; }

    public int? ApplicationsDuration { get; set; }

    public JobStatus Status { get; set; }
    public int? RequiredEmployees { get; set; }

    public string CityName { get; set; }

    public string JobTypeName { get; set; }

    public DateTime Created { get; set; }

    public int CreatedBy { get; set; }
    public string EmployerFullName { get; set; }
    public bool DeletedByAdmin { get; set; }
}
