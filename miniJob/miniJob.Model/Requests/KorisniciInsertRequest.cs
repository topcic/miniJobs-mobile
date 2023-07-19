using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace miniJob.Model.Requests
{
    public class KorisniciInsertRequest
    {
        public string role { get; set; }
        public string ime { get; set; }
        public string prezime { get; set; }
        public string korisnickoIme { get; set; }
        public string lozinka { get; set; }
        public string lozinkaPotvrda { get; set; }
        public int Status { get; set; }
        public string email { get; set; }
        public DateTime? DatumRegistracije { get; set; }

        public string brojTelefona { get; set; }
        public string lokacija { get; set; }
        public string nazivFirme { get; set; }
       

    }
}
