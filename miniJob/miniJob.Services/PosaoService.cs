using miniJob.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace miniJob.Services
{
    public class PosaoService : IPosaoService
    {
        List<Posao> poslovi = new List<Posao>()
{
    new Posao()
    {
        id = 1,
        naziv = "Software Engineer",
        opis = "Seeking a skilled software engineer to develop and maintain high-quality software solutions. Responsibilities include coding, debugging, and collaborating with cross-functional teams.",
        adresa = "123 Main Street, City, State",
        status = "Open",
        datum_kreiranja = "2023-07-01",
        deadline = "2023-07-15",
        Cijena = 80000,
        brojAplikanata = 10
    },
    new Posao()
    {
        id = 2,
        naziv = "Marketing Manager",
        opis = "Looking for an experienced marketing professional to develop and implement effective marketing strategies. Responsibilities include market research, campaign management, and team coordination.",
        adresa = "456 Elm Street, City, State",
        status = "Open",
        datum_kreiranja = "2023-07-02",
        deadline = "2023-07-16",
        Cijena = 90000,
        brojAplikanata = 8
    },
    new Posao()
    {
        id = 3,
        naziv = "Graphic Designer",
        opis = "Hiring a creative graphic designer to produce visually appealing designs for various projects. Responsibilities include creating layouts, illustrations, and collaborating with clients.",
        adresa = "789 Oak Street, City, State",
        status = "Open",
        datum_kreiranja = "2023-07-03",
        deadline = "2023-07-17",
        Cijena = 60000,
        brojAplikanata = 5
    }
};

        public IList<Posao> Get()
        {
            return poslovi;
        }
    }
}
