using AutoMapper;
using Azure.Core;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace miniJob.Services
{
    public class MappingProfile:Profile
    {
        public MappingProfile()
        {
            CreateMap<Database.KorisnickiNalog,Model.KorisnickiNalog>();
           CreateMap<Model.Requests.KorisniciInsertRequest, Database.KorisnickiNalog>();
            CreateMap<Model.Requests.KorisniciUpdateRequest, Database.KorisnickiNalog>();
            CreateMap<Model.Requests.KorisniciInsertRequest,Database.Aplikant>();
            CreateMap<Model.Requests.KorisniciInsertRequest, Database.Poslodavac>();
        }
    }
}
