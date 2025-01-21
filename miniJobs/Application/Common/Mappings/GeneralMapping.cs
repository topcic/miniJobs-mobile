using Application.Common.Exceptions;
using AutoMapper;
using Domain.Dtos;
using Domain.Enums;
using Microsoft.AspNetCore.Identity;

namespace Application.Common.Mappings;

public class GeneralMapping : Profile
{
    public GeneralMapping()
    {

        CreateMap<IReadOnlyDictionary<string, string>, QueryParametersDto>()
        .ForMember(dest => dest.SortBy, opt => opt.MapFrom(src =>
        src.ContainsKey("sortBy") && !string.IsNullOrWhiteSpace(src["sortBy"])
            ? char.ToUpper(src["sortBy"][0]) + src["sortBy"].Substring(1)
            : "Id"))
        .ForMember(dest => dest.SortOrder, opt => opt.MapFrom((src, dest) =>
        {
            var sortOrder = QueryParameterExtension.TryParseParameter<int>(src, "sortOrder");
            return sortOrder != null && sortOrder != 0 ? (SortOrder)sortOrder : SortOrder.ASC;
        }))
        .ForMember(dest => dest.Limit, opt => opt.MapFrom(src => QueryParameterExtension.TryParseParameter<int>(src, "limit") != 0 ? QueryParameterExtension.TryParseParameter<int>(src, "limit") : 10))
        .ForMember(dest => dest.Offset, opt => opt.MapFrom(src => QueryParameterExtension.TryParseParameter<int>(src, "offset") != 0 ? QueryParameterExtension.TryParseParameter<int>(src, "offset") : 0))
        .ForMember(dest => dest.SearchText, opt => opt.MapFrom(src =>!String.IsNullOrEmpty( QueryParameterExtension.TryParseParameter(src, "searchText")) 
        ? QueryParameterExtension.TryParseParameter(src, "searchText") : ""));

    }
}