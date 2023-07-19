using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace miniJob.Model
{
    public class Poslodavac
    {
        public int Id { get; set; }
        public string? Ime { get; set; }

        public string? Prezime { get; set; }
        public string? KorisnickoIme { get; set; }

        public DateTime? DatumRegistracije { get; set; }

        public string? BrojTelefona { get; set; }

        public int? Status { get; set; }
        public string? NazivFirme { get; set; }

    }
}
