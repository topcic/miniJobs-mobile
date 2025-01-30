using Domain.Dtos;

namespace Domain.Interfaces;

public interface IStatisticRepository
{
    Task<OverallStatisticDto?> GetOverallStatisticsAsync();
}