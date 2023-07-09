using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace miniJob.Model
{
    public  class Posao
    {
        [Key]
        public int id { get; set; }
        public string naziv { get; set; }
        public string opis { get; set; }
        public string adresa { get; set; }
        public string status { get; set; }
        public string datum_kreiranja { get; set; }
        public string deadline { get; set; }
        public int Cijena { get; set; }
        public int brojAplikanata { get; set; }
    }
}
