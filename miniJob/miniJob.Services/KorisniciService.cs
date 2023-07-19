using AutoMapper;
using miniJob.Model.Requests;
using miniJob.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace miniJob.Services
{
    public class KorisniciService:IKorisniciService
    {
        miniJobsContext _db;
        public IMapper _mapper { get; set; }
        public KorisniciService(miniJobsContext miniJobsContext,IMapper mapper)
        {
            _db= miniJobsContext;
            _mapper= mapper;
        }

        public List<Model.KorisnickiNalog> Get()
        {
            var entityList=_db.KorisnickiNalogs.ToList();
            return _mapper.Map<List<Model.KorisnickiNalog>>(entityList);
        }

        public Model.KorisnickiNalog Insert(KorisniciInsertRequest request)
        {
            var korisnik = new KorisnickiNalog();
            _mapper.Map(request, korisnik);

            _db.KorisnickiNalogs.Add(korisnik);
            _db.SaveChanges();

            return _mapper.Map<Model.KorisnickiNalog>(korisnik);
        }
    }
}
