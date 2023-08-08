using AutoMapper;
using Microsoft.EntityFrameworkCore;
using miniJob.Model.Requests;
using miniJob.Model.SearchObjects;
using miniJob.Services.Database;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace miniJob.Services
{
    public class KorisniciService :BaseService<Model.KorisnickiNalog,Database.KorisnickiNalog,Model.SearchObjects.KorisnikSearchObject> ,IKorisniciService
    {

        public KorisniciService(miniJobsContext miniJobsContext, IMapper mapper):base(miniJobsContext, mapper) 
        {
    
        }


        public override  IQueryable<KorisnickiNalog> AddFilter(IQueryable<KorisnickiNalog> query, KorisnikSearchObject? search = null)
        {
            if (!string.IsNullOrWhiteSpace(search?.korisnickoIme))
            {
                query = query.Where(k => k.KorisnickoIme.StartsWith(search.korisnickoIme));
            }
            return base.AddFilter(query, search);
        }

        public Model.KorisnickiNalog Insert(KorisniciInsertRequest request)
        {
            var korisnik = new KorisnickiNalog();
            if (request.role == "Aplikant")
            {
                korisnik.Aplikant = new Aplikant();
                _mapper.Map(request, korisnik.Aplikant);
                _mapper.Map(request, korisnik);
            }
            else
            {
                korisnik.Poslodavac = new Poslodavac();
                _mapper.Map(request, korisnik.Poslodavac);
                _mapper.Map(request, korisnik);
            }


            korisnik.LozinkaSalt = GenerateSalt();
            korisnik.LozinkaHash = GenereteHash(korisnik.LozinkaSalt, request.Lozinka);

            _db.KorisnickiNalogs.Add(korisnik);
            _db.SaveChanges();

            return _mapper.Map<Model.KorisnickiNalog>(korisnik);
        }
        public static string GenerateSalt()
        {
            RNGCryptoServiceProvider provider = new RNGCryptoServiceProvider();
            var byteArray = new byte[16];
            provider.GetBytes(byteArray);

            return Convert.ToBase64String(byteArray);
        }


        public static string GenereteHash(string salt, string lozinka)
        {
            byte[] src = Convert.FromBase64String(salt);
            byte[] bytes = Encoding.Unicode.GetBytes(lozinka);
            byte[] dst = new byte[src.Length + bytes.Length];

            System.Buffer.BlockCopy(src, 0, dst, 0, src.Length);
            System.Buffer.BlockCopy(bytes, 0, dst, src.Length, bytes.Length);

            HashAlgorithm algorithm = HashAlgorithm.Create("SHA1");
            byte[] inArray = algorithm.ComputeHash(dst);
            return Convert.ToBase64String(inArray);


        }
        public Model.KorisnickiNalog Update(int id, KorisniciUpdateRequest request)
        {
            var entity = _db.KorisnickiNalogs.Find(id);
            if (entity == null)
            {
                _mapper.Map(request, entity);
                _db.SaveChanges();

            }
            return _mapper.Map<Model.KorisnickiNalog>(entity);
        }

        public override IQueryable<KorisnickiNalog> AddInclude(IQueryable<KorisnickiNalog> query, KorisnikSearchObject? search = null)
            
        {
            if (search?.uloga == "Aplikant")
                query.Include("Aplikants");
            else if(search?.uloga == "Poslodavac")
                query.Include("Poslodavacs");
            return base.AddInclude(query, search);
        }
    }
}
