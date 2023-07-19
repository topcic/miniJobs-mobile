using System;
using System.Collections.Generic;

namespace miniJob.Services.Database;

public partial class KorisnickiNalog
{
    public int Id { get; set; }
    public string? Ime { get; set; }

    public string? Prezime { get; set; }
    public string? KorisnickoIme { get; set; }

    public DateTime? DatumRegistracije { get; set; }

    public string? BrojTelefona { get; set; }

    public int? Status { get; set; }

    public string? Spol { get; set; }

    public string? DatumRodjenja { get; set; }

    public string? Email { get; set; }

    public bool EmailPotvrđen { get; set; }

    public string? Token { get; set; }

    public string? RefreshToken { get; set; }

    public DateTime RefreshTokenExpiryTime { get; set; }

    public string? Lozinka { get; set; }

    public string? SlikaKorisnika { get; set; }

    public bool? IsAdmin { get; set; }

    public virtual Aplikant? Aplikant { get; set; }

    public virtual ICollection<Ocjena> OcjenaOcjenjenid1Navigations { get; set; } = new List<Ocjena>();

    public virtual ICollection<Ocjena> OcjenaOcjenjujes { get; set; } = new List<Ocjena>();



    public virtual Poslodavac? Poslodavac { get; set; }

    public virtual ICollection<VerifikacijaEmail> VerifikacijaEmails { get; set; } = new List<VerifikacijaEmail>();
}
