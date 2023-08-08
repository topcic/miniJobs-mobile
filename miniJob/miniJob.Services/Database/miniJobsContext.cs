using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace miniJob.Services.Database;

public partial class miniJobsContext : Microsoft.EntityFrameworkCore.DbContext
{
    public miniJobsContext()
    {
    }

    public miniJobsContext(DbContextOptions<miniJobsContext> options)
        : base(options)
    {
    }

    public virtual DbSet<ApliciraniPosao> ApliciraniPosaos { get; set; }

    public virtual DbSet<Aplikant> Aplikants { get; set; }

    public virtual DbSet<AplikantPosaoTip> AplikantPosaoTips { get; set; }

    public virtual DbSet<Drzava> Drzavas { get; set; }

    public virtual DbSet<KorisnickiNalog> KorisnickiNalogs { get; set; }

    public virtual DbSet<Ocjena> Ocjenas { get; set; }

    public virtual DbSet<Opstina> Opstinas { get; set; }

    public virtual DbSet<Pitanje> Pitanjes { get; set; }

    public virtual DbSet<PitanjeOdgovor> PitanjeOdgovors { get; set; }



    public virtual DbSet<PonudjeniOdgovor> PonudjeniOdgovors { get; set; }



    public virtual DbSet<Posao> Posaos { get; set; }

    public virtual DbSet<PosaoPitanje> PosaoPitanjes { get; set; }

    public virtual DbSet<PosaoTip> PosaoTips { get; set; }

    public virtual DbSet<Poslodavac> Poslodavacs { get; set; }

    public virtual DbSet<Preporuka> Preporukas { get; set; }

    public virtual DbSet<PreporukaTipPosla> PreporukaTipPoslas { get; set; }

    public virtual DbSet<SpremljeniPosao> SpremljeniPosaos { get; set; }

    public virtual DbSet<VerifikacijaEmail> VerifikacijaEmails { get; set; }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
        => optionsBuilder.UseSqlServer("Server=localhost;Database=demo_db291;Trusted_Connection=true;MultipleActiveResultSets=true;TrustServerCertificate=True");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<ApliciraniPosao>(entity =>
        {
            entity.ToTable("ApliciraniPosao");

            entity.HasIndex(e => e.AplikantId, "IX_ApliciraniPosao_aplikant_id");

            entity.HasIndex(e => e.PosaoId, "IX_ApliciraniPosao_posao_id");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.AplikantId).HasColumnName("aplikant_id");
            entity.Property(e => e.DatumApliciranja).HasColumnName("datum_apliciranja");
            entity.Property(e => e.PosaoId).HasColumnName("posao_id");
            entity.Property(e => e.Status).HasColumnName("status");

            entity.HasOne(d => d.Aplikant).WithMany(p => p.ApliciraniPosaos)
                .HasForeignKey(d => d.AplikantId)
                .OnDelete(DeleteBehavior.ClientSetNull);

            entity.HasOne(d => d.Posao).WithMany(p => p.ApliciraniPosaos)
                .HasForeignKey(d => d.PosaoId)
                .OnDelete(DeleteBehavior.ClientSetNull);
        });

        modelBuilder.Entity<Aplikant>(entity =>
        {
            entity.ToTable("Aplikant");

            entity.HasIndex(e => e.OpstinaRodjenjaId, "IX_Aplikant_opstina_rodjenja_id");

            entity.HasIndex(e => e.PreporukaId, "IX_Aplikant_preporuka_id");

            entity.Property(e => e.Id)
                .ValueGeneratedNever()
                .HasColumnName("id");
            entity.Property(e => e.Cv).HasColumnName("CV");
      
            entity.Property(e => e.Iskustvo).HasColumnName("iskustvo");
            entity.Property(e => e.NivoObrazovanja).HasColumnName("nivoObrazovanja");
            entity.Property(e => e.Opis).HasColumnName("opis");
            entity.Property(e => e.OpstinaRodjenjaId).HasColumnName("opstina_rodjenja_id");
            entity.Property(e => e.PreporukaId).HasColumnName("preporuka_id");
       
            entity.Property(e => e.PrijedlogSatince).HasColumnName("prijedlogSatince");
            entity.Property(e => e.Slika).HasColumnName("slika");

            entity.HasOne(d => d.IdNavigation).WithOne(p => p.Aplikant).HasForeignKey<Aplikant>(d => d.Id);

            entity.HasOne(d => d.OpstinaRodjenja).WithMany(p => p.Aplikants).HasForeignKey(d => d.OpstinaRodjenjaId);

            entity.HasOne(d => d.Preporuka).WithMany(p => p.Aplikants).HasForeignKey(d => d.PreporukaId);
        });

        modelBuilder.Entity<AplikantPosaoTip>(entity =>
        {
            entity.ToTable("aplikantPosaoTip");

            entity.HasIndex(e => e.Aplikantid1, "IX_aplikantPosaoTip_aplikantid");

            entity.HasIndex(e => e.PosaoTipid1, "IX_aplikantPosaoTip_posaoTipid");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.AplikantId).HasColumnName("aplikant_id");
            entity.Property(e => e.Aplikantid1).HasColumnName("aplikantid");
            entity.Property(e => e.PosaoTipId).HasColumnName("posaoTip_id");
            entity.Property(e => e.PosaoTipid1).HasColumnName("posaoTipid");

            entity.HasOne(d => d.Aplikantid1Navigation).WithMany(p => p.AplikantPosaoTips).HasForeignKey(d => d.Aplikantid1);

            entity.HasOne(d => d.PosaoTipid1Navigation).WithMany(p => p.AplikantPosaoTips).HasForeignKey(d => d.PosaoTipid1);
        });

        modelBuilder.Entity<Drzava>(entity =>
        {
            entity.ToTable("Drzava");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Naziv).HasColumnName("naziv");
        });

        modelBuilder.Entity<KorisnickiNalog>(entity =>
        {
            entity.ToTable("KorisnickiNalog");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.BrojTelefona).HasColumnName("brojTelefona");
            entity.Property(e => e.DatumRegistracije).HasColumnName("datumRegistracije");
            entity.Property(e => e.DatumRodjenja).HasColumnName("datumRodjenja");
            entity.Property(e => e.Email).HasColumnName("email");
            entity.Property(e => e.EmailPotvrđen).HasColumnName("emailPotvrđen");
            entity.Property(e => e.IsAdmin).HasColumnName("isAdmin");
            entity.Property(e => e.KorisnickoIme).HasColumnName("korisnickoIme");
            entity.Property(e => e.LozinkaSalt).HasColumnName("lozinkaSalt");
            entity.Property(e => e.LozinkaHash).HasColumnName("lozinkaHash");
            entity.Property(e => e.RefreshToken).HasColumnName("refreshToken");
            entity.Property(e => e.RefreshTokenExpiryTime).HasColumnName("refreshTokenExpiryTime");
            entity.Property(e => e.SlikaKorisnika).HasColumnName("slika_korisnika");
            entity.Property(e => e.Spol).HasColumnName("spol");
            entity.Property(e => e.Status).HasColumnName("status");
            entity.Property(e => e.Token).HasColumnName("token");
        });

        modelBuilder.Entity<Ocjena>(entity =>
        {
            entity.ToTable("Ocjena");

            entity.HasIndex(e => e.ApliciraniPosaoId, "IX_Ocjena_apliciraniPosao_id");

            entity.HasIndex(e => e.Ocjenjenid1, "IX_Ocjena_ocjenjenid");

            entity.HasIndex(e => e.OcjenjujeId, "IX_Ocjena_ocjenjuje_id");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.ApliciraniPosaoId).HasColumnName("apliciraniPosao_id");
            entity.Property(e => e.Komentar).HasColumnName("komentar");
            entity.Property(e => e.OcjenjenId).HasColumnName("ocjenjen_id");
            entity.Property(e => e.Ocjenjenid1).HasColumnName("ocjenjenid");
            entity.Property(e => e.OcjenjujeId).HasColumnName("ocjenjuje_id");
            entity.Property(e => e.Vrijednost).HasColumnName("vrijednost");

            entity.HasOne(d => d.ApliciraniPosao).WithMany(p => p.Ocjenas)
                .HasForeignKey(d => d.ApliciraniPosaoId)
                .OnDelete(DeleteBehavior.ClientSetNull);

            entity.HasOne(d => d.Ocjenjenid1Navigation).WithMany(p => p.OcjenaOcjenjenid1Navigations).HasForeignKey(d => d.Ocjenjenid1);

            entity.HasOne(d => d.Ocjenjuje).WithMany(p => p.OcjenaOcjenjujes)
                .HasForeignKey(d => d.OcjenjujeId)
                .OnDelete(DeleteBehavior.ClientSetNull);
        });

        modelBuilder.Entity<Opstina>(entity =>
        {
            entity.ToTable("Opstina");

            entity.HasIndex(e => e.DrzavaId, "IX_Opstina_drzava_id");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Description).HasColumnName("description");
            entity.Property(e => e.DrzavaId).HasColumnName("drzava_id");

            entity.HasOne(d => d.Drzava).WithMany(p => p.Opstinas).HasForeignKey(d => d.DrzavaId);
        });

        modelBuilder.Entity<Pitanje>(entity =>
        {
            entity.ToTable("Pitanje");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Naziv).HasColumnName("naziv");
        });

        modelBuilder.Entity<PitanjeOdgovor>(entity =>
        {
            entity.ToTable("PitanjeOdgovor");

            entity.HasIndex(e => e.PonudjeniOdgovorId, "IX_PitanjeOdgovor_ponudjeniOdgovor_id");

            entity.HasIndex(e => e.PosaoPitanjeId, "IX_PitanjeOdgovor_posaoPitanje_id");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.PonudjeniOdgovorId).HasColumnName("ponudjeniOdgovor_id");
            entity.Property(e => e.PosaoPitanjeId).HasColumnName("posaoPitanje_id");

            entity.HasOne(d => d.PonudjeniOdgovor).WithMany(p => p.PitanjeOdgovors)
                .HasForeignKey(d => d.PonudjeniOdgovorId)
                .OnDelete(DeleteBehavior.ClientSetNull);

            entity.HasOne(d => d.PosaoPitanje).WithMany(p => p.PitanjeOdgovors)
                .HasForeignKey(d => d.PosaoPitanjeId)
                .OnDelete(DeleteBehavior.ClientSetNull);
        });

      

        modelBuilder.Entity<PonudjeniOdgovor>(entity =>
        {
            entity.ToTable("PonudjeniOdgovor");

            entity.HasIndex(e => e.PitanjeId, "IX_PonudjeniOdgovor_pitanje_id");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Odgovor).HasColumnName("odgovor");
            entity.Property(e => e.PitanjeId).HasColumnName("pitanje_id");

            entity.HasOne(d => d.Pitanje).WithMany(p => p.PonudjeniOdgovors).HasForeignKey(d => d.PitanjeId);
        });

       
        modelBuilder.Entity<Posao>(entity =>
        {
            entity.ToTable("Posao");

            entity.HasIndex(e => e.OpstinaId, "IX_Posao_opstina_id");

            entity.HasIndex(e => e.PosaoTipId, "IX_Posao_posaoTip_id");

            entity.HasIndex(e => e.PoslodavacId, "IX_Posao_poslodavac_id");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Adresa).HasColumnName("adresa");
            entity.Property(e => e.BrojAplikanata).HasColumnName("brojAplikanata");
            entity.Property(e => e.DatumKreiranja).HasColumnName("datum_kreiranja");
            entity.Property(e => e.Deadline).HasColumnName("deadline");
            entity.Property(e => e.Naziv).HasColumnName("naziv");
            entity.Property(e => e.Opis).HasColumnName("opis");
            entity.Property(e => e.OpstinaId).HasColumnName("opstina_id");
            entity.Property(e => e.PosaoTipId).HasColumnName("posaoTip_id");
            entity.Property(e => e.PoslodavacId).HasColumnName("poslodavac_id");
            entity.Property(e => e.Status).HasColumnName("status");

            entity.HasOne(d => d.Opstina).WithMany(p => p.Posaos).HasForeignKey(d => d.OpstinaId);

            entity.HasOne(d => d.PosaoTip).WithMany(p => p.Posaos).HasForeignKey(d => d.PosaoTipId);

            entity.HasOne(d => d.Poslodavac).WithMany(p => p.Posaos).HasForeignKey(d => d.PoslodavacId);
        });

        modelBuilder.Entity<PosaoPitanje>(entity =>
        {
            entity.ToTable("PosaoPitanje");

            entity.HasIndex(e => e.PitanjeId, "IX_PosaoPitanje_pitanje_id");

            entity.HasIndex(e => e.PosaoId, "IX_PosaoPitanje_posao_id");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.PitanjeId).HasColumnName("pitanje_id");
            entity.Property(e => e.PosaoId).HasColumnName("posao_id");

            entity.HasOne(d => d.Pitanje).WithMany(p => p.PosaoPitanjes).HasForeignKey(d => d.PitanjeId);

            entity.HasOne(d => d.Posao).WithMany(p => p.PosaoPitanjes).HasForeignKey(d => d.PosaoId);
        });

        modelBuilder.Entity<PosaoTip>(entity =>
        {
            entity.ToTable("PosaoTip");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.Naziv).HasColumnName("naziv");
        });

        modelBuilder.Entity<Poslodavac>(entity =>
        {
            entity.ToTable("Poslodavac");

            entity.Property(e => e.Id)
                .ValueGeneratedNever()
                .HasColumnName("id");
            entity.Property(e => e.Adresa).HasColumnName("adresa");
         

            entity.HasOne(d => d.IdNavigation).WithOne(p => p.Poslodavac).HasForeignKey<Poslodavac>(d => d.Id);
        });

        modelBuilder.Entity<Preporuka>(entity =>
        {
            entity.ToTable("Preporuka");

            entity.HasIndex(e => e.OpstinaId, "IX_Preporuka_opstina_id");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.OpstinaId).HasColumnName("opstina_id");

            entity.HasOne(d => d.Opstina).WithMany(p => p.Preporukas).HasForeignKey(d => d.OpstinaId);
        });

        modelBuilder.Entity<PreporukaTipPosla>(entity =>
        {
            entity.ToTable("PreporukaTipPosla");

            entity.HasIndex(e => e.PosaoTipId, "IX_PreporukaTipPosla_posaoTip_id");

            entity.HasIndex(e => e.PreporukaId, "IX_PreporukaTipPosla_preporuka_id");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.PosaoTipId).HasColumnName("posaoTip_id");
            entity.Property(e => e.PreporukaId).HasColumnName("preporuka_id");

            entity.HasOne(d => d.PosaoTip).WithMany(p => p.PreporukaTipPoslas).HasForeignKey(d => d.PosaoTipId);

            entity.HasOne(d => d.Preporuka).WithMany(p => p.PreporukaTipPoslas).HasForeignKey(d => d.PreporukaId);
        });

        modelBuilder.Entity<SpremljeniPosao>(entity =>
        {
            entity.ToTable("SpremljeniPosao");

            entity.HasIndex(e => e.AplikantId, "IX_SpremljeniPosao_aplikant_id");

            entity.HasIndex(e => e.PosaoId, "IX_SpremljeniPosao_posao_id");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.AplikantId).HasColumnName("aplikant_id");
            entity.Property(e => e.PosaoId).HasColumnName("posao_id");
            entity.Property(e => e.Status).HasColumnName("status");

            entity.HasOne(d => d.Aplikant).WithMany(p => p.SpremljeniPosaos)
                .HasForeignKey(d => d.AplikantId)
                .OnDelete(DeleteBehavior.ClientSetNull);

            entity.HasOne(d => d.Posao).WithMany(p => p.SpremljeniPosaos)
                .HasForeignKey(d => d.PosaoId)
                .OnDelete(DeleteBehavior.ClientSetNull);
        });

        modelBuilder.Entity<VerifikacijaEmail>(entity =>
        {
            entity.ToTable("verifikacijaEmail");

            entity.HasIndex(e => e.KorisnikId, "IX_verifikacijaEmail_korisnik_id");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.KorisnikId).HasColumnName("korisnik_id");
            entity.Property(e => e.VerifikaciskiKod).HasColumnName("verifikaciskiKod");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.VerifikacijaEmails).HasForeignKey(d => d.KorisnikId);
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
