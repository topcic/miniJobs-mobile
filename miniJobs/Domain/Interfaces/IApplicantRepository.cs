﻿using Domain.Entities;

namespace Domain.Interfaces;

public interface IApplicantRepository : IGenericRepository<Applicant, int>
{
    Task<IEnumerable<Applicant>> SearchAsync(string searchText, int limit, int offset, int? cityId, int? jobTypeId);
    Task<int> SearchCountAsync(string searchText, int? cityId, int? jobTypeId);

}