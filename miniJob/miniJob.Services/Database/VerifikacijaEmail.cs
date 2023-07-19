using System;
using System.Collections.Generic;

namespace miniJob.Services.Database;

public partial class VerifikacijaEmail
{
    public int Id { get; set; }

    public int KorisnikId { get; set; }

    public int VerifikaciskiKod { get; set; }

    public virtual KorisnickiNalog Korisnik { get; set; } = null!;
}
