using Domain.Dtos;
using Domain.Entities;

namespace Domain.Interfaces;

public interface IApplicantRepository : IGenericRepository<Applicant, int>
{
    Task<IEnumerable<ApplicantDTO>> SearchAsync(string searchText, int limit, int offset, int? cityId, int? jobTypeId);
    Task<int> SearchCountAsync(string searchText, int? cityId, int? jobTypeId);
    Task<ApplicantDTO> GetWithDetailsAsync(int id);
    Task<int> PublicCountAsync(Dictionary<string, string> parameters = null);
    Task<IEnumerable<ApplicantDTO>> PublicFindPaginationAsync(Dictionary<string, string> parameters = null);
}