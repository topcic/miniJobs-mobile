using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace miniJob.Services.Migrations
{
    /// <inheritdoc />
    public partial class init : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Drzava",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    naziv = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Drzava", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "KorisnickiNalog",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Ime = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Prezime = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    korisnickoIme = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    datumRegistracije = table.Column<DateTime>(type: "datetime2", nullable: true),
                    brojTelefona = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    status = table.Column<int>(type: "int", nullable: true),
                    spol = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    datumRodjenja = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    email = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    emailPotvrđen = table.Column<bool>(type: "bit", nullable: false),
                    token = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    refreshToken = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    refreshTokenExpiryTime = table.Column<DateTime>(type: "datetime2", nullable: false),
                    lozinkaHash = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    lozinkaSalt = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    slika_korisnika = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    isAdmin = table.Column<bool>(type: "bit", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_KorisnickiNalog", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "Pitanje",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    naziv = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Pitanje", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "PosaoTip",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    naziv = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PosaoTip", x => x.id);
                });

            migrationBuilder.CreateTable(
                name: "Opstina",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    description = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    drzava_id = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Opstina", x => x.id);
                    table.ForeignKey(
                        name: "FK_Opstina_Drzava_drzava_id",
                        column: x => x.drzava_id,
                        principalTable: "Drzava",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Poslodavac",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false),
                    adresa = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    NazivFirme = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Poslodavac", x => x.id);
                    table.ForeignKey(
                        name: "FK_Poslodavac_KorisnickiNalog_id",
                        column: x => x.id,
                        principalTable: "KorisnickiNalog",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "verifikacijaEmail",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    korisnik_id = table.Column<int>(type: "int", nullable: false),
                    verifikaciskiKod = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_verifikacijaEmail", x => x.id);
                    table.ForeignKey(
                        name: "FK_verifikacijaEmail_KorisnickiNalog_korisnik_id",
                        column: x => x.korisnik_id,
                        principalTable: "KorisnickiNalog",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "PonudjeniOdgovor",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    odgovor = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    pitanje_id = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PonudjeniOdgovor", x => x.id);
                    table.ForeignKey(
                        name: "FK_PonudjeniOdgovor_Pitanje_pitanje_id",
                        column: x => x.pitanje_id,
                        principalTable: "Pitanje",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Preporuka",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    opstina_id = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Preporuka", x => x.id);
                    table.ForeignKey(
                        name: "FK_Preporuka_Opstina_opstina_id",
                        column: x => x.opstina_id,
                        principalTable: "Opstina",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Posao",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    naziv = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    opis = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    adresa = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    status = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    datum_kreiranja = table.Column<DateTime>(type: "datetime2", nullable: false),
                    deadline = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Cijena = table.Column<int>(type: "int", nullable: false),
                    brojAplikanata = table.Column<int>(type: "int", nullable: false),
                    opstina_id = table.Column<int>(type: "int", nullable: false),
                    posaoTip_id = table.Column<int>(type: "int", nullable: false),
                    poslodavac_id = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Posao", x => x.id);
                    table.ForeignKey(
                        name: "FK_Posao_Opstina_opstina_id",
                        column: x => x.opstina_id,
                        principalTable: "Opstina",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Posao_PosaoTip_posaoTip_id",
                        column: x => x.posaoTip_id,
                        principalTable: "PosaoTip",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Posao_Poslodavac_poslodavac_id",
                        column: x => x.poslodavac_id,
                        principalTable: "Poslodavac",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Aplikant",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false),
                    prijedlogSatince = table.Column<int>(type: "int", nullable: true),
                    opis = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    iskustvo = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    slika = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    nivoObrazovanja = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    CV = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    opstina_rodjenja_id = table.Column<int>(type: "int", nullable: true),
                    preporuka_id = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Aplikant", x => x.id);
                    table.ForeignKey(
                        name: "FK_Aplikant_KorisnickiNalog_id",
                        column: x => x.id,
                        principalTable: "KorisnickiNalog",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Aplikant_Opstina_opstina_rodjenja_id",
                        column: x => x.opstina_rodjenja_id,
                        principalTable: "Opstina",
                        principalColumn: "id");
                    table.ForeignKey(
                        name: "FK_Aplikant_Preporuka_preporuka_id",
                        column: x => x.preporuka_id,
                        principalTable: "Preporuka",
                        principalColumn: "id");
                });

            migrationBuilder.CreateTable(
                name: "PreporukaTipPosla",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    posaoTip_id = table.Column<int>(type: "int", nullable: false),
                    preporuka_id = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PreporukaTipPosla", x => x.id);
                    table.ForeignKey(
                        name: "FK_PreporukaTipPosla_PosaoTip_posaoTip_id",
                        column: x => x.posaoTip_id,
                        principalTable: "PosaoTip",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_PreporukaTipPosla_Preporuka_preporuka_id",
                        column: x => x.preporuka_id,
                        principalTable: "Preporuka",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "PosaoPitanje",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    pitanje_id = table.Column<int>(type: "int", nullable: false),
                    posao_id = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PosaoPitanje", x => x.id);
                    table.ForeignKey(
                        name: "FK_PosaoPitanje_Pitanje_pitanje_id",
                        column: x => x.pitanje_id,
                        principalTable: "Pitanje",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_PosaoPitanje_Posao_posao_id",
                        column: x => x.posao_id,
                        principalTable: "Posao",
                        principalColumn: "id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "ApliciraniPosao",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    status = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    datum_apliciranja = table.Column<DateTime>(type: "datetime2", nullable: false),
                    aplikant_id = table.Column<int>(type: "int", nullable: false),
                    posao_id = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ApliciraniPosao", x => x.id);
                    table.ForeignKey(
                        name: "FK_ApliciraniPosao_Aplikant_aplikant_id",
                        column: x => x.aplikant_id,
                        principalTable: "Aplikant",
                        principalColumn: "id");
                    table.ForeignKey(
                        name: "FK_ApliciraniPosao_Posao_posao_id",
                        column: x => x.posao_id,
                        principalTable: "Posao",
                        principalColumn: "id");
                });

            migrationBuilder.CreateTable(
                name: "aplikantPosaoTip",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    aplikant_id = table.Column<int>(type: "int", nullable: false),
                    aplikantid = table.Column<int>(type: "int", nullable: true),
                    posaoTip_id = table.Column<int>(type: "int", nullable: false),
                    posaoTipid = table.Column<int>(type: "int", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_aplikantPosaoTip", x => x.id);
                    table.ForeignKey(
                        name: "FK_aplikantPosaoTip_Aplikant_aplikantid",
                        column: x => x.aplikantid,
                        principalTable: "Aplikant",
                        principalColumn: "id");
                    table.ForeignKey(
                        name: "FK_aplikantPosaoTip_PosaoTip_posaoTipid",
                        column: x => x.posaoTipid,
                        principalTable: "PosaoTip",
                        principalColumn: "id");
                });

            migrationBuilder.CreateTable(
                name: "SpremljeniPosao",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    status = table.Column<int>(type: "int", nullable: false),
                    aplikant_id = table.Column<int>(type: "int", nullable: false),
                    posao_id = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_SpremljeniPosao", x => x.id);
                    table.ForeignKey(
                        name: "FK_SpremljeniPosao_Aplikant_aplikant_id",
                        column: x => x.aplikant_id,
                        principalTable: "Aplikant",
                        principalColumn: "id");
                    table.ForeignKey(
                        name: "FK_SpremljeniPosao_Posao_posao_id",
                        column: x => x.posao_id,
                        principalTable: "Posao",
                        principalColumn: "id");
                });

            migrationBuilder.CreateTable(
                name: "PitanjeOdgovor",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    posaoPitanje_id = table.Column<int>(type: "int", nullable: false),
                    ponudjeniOdgovor_id = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PitanjeOdgovor", x => x.id);
                    table.ForeignKey(
                        name: "FK_PitanjeOdgovor_PonudjeniOdgovor_ponudjeniOdgovor_id",
                        column: x => x.ponudjeniOdgovor_id,
                        principalTable: "PonudjeniOdgovor",
                        principalColumn: "id");
                    table.ForeignKey(
                        name: "FK_PitanjeOdgovor_PosaoPitanje_posaoPitanje_id",
                        column: x => x.posaoPitanje_id,
                        principalTable: "PosaoPitanje",
                        principalColumn: "id");
                });

            migrationBuilder.CreateTable(
                name: "Ocjena",
                columns: table => new
                {
                    id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    vrijednost = table.Column<int>(type: "int", nullable: false),
                    komentar = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    ocjenjen_id = table.Column<int>(type: "int", nullable: false),
                    ocjenjenid = table.Column<int>(type: "int", nullable: true),
                    ocjenjuje_id = table.Column<int>(type: "int", nullable: false),
                    apliciraniPosao_id = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Ocjena", x => x.id);
                    table.ForeignKey(
                        name: "FK_Ocjena_ApliciraniPosao_apliciraniPosao_id",
                        column: x => x.apliciraniPosao_id,
                        principalTable: "ApliciraniPosao",
                        principalColumn: "id");
                    table.ForeignKey(
                        name: "FK_Ocjena_KorisnickiNalog_ocjenjenid",
                        column: x => x.ocjenjenid,
                        principalTable: "KorisnickiNalog",
                        principalColumn: "id");
                    table.ForeignKey(
                        name: "FK_Ocjena_KorisnickiNalog_ocjenjuje_id",
                        column: x => x.ocjenjuje_id,
                        principalTable: "KorisnickiNalog",
                        principalColumn: "id");
                });

            migrationBuilder.CreateIndex(
                name: "IX_ApliciraniPosao_aplikant_id",
                table: "ApliciraniPosao",
                column: "aplikant_id");

            migrationBuilder.CreateIndex(
                name: "IX_ApliciraniPosao_posao_id",
                table: "ApliciraniPosao",
                column: "posao_id");

            migrationBuilder.CreateIndex(
                name: "IX_Aplikant_opstina_rodjenja_id",
                table: "Aplikant",
                column: "opstina_rodjenja_id");

            migrationBuilder.CreateIndex(
                name: "IX_Aplikant_preporuka_id",
                table: "Aplikant",
                column: "preporuka_id");

            migrationBuilder.CreateIndex(
                name: "IX_aplikantPosaoTip_aplikantid",
                table: "aplikantPosaoTip",
                column: "aplikantid");

            migrationBuilder.CreateIndex(
                name: "IX_aplikantPosaoTip_posaoTipid",
                table: "aplikantPosaoTip",
                column: "posaoTipid");

            migrationBuilder.CreateIndex(
                name: "IX_Ocjena_apliciraniPosao_id",
                table: "Ocjena",
                column: "apliciraniPosao_id");

            migrationBuilder.CreateIndex(
                name: "IX_Ocjena_ocjenjenid",
                table: "Ocjena",
                column: "ocjenjenid");

            migrationBuilder.CreateIndex(
                name: "IX_Ocjena_ocjenjuje_id",
                table: "Ocjena",
                column: "ocjenjuje_id");

            migrationBuilder.CreateIndex(
                name: "IX_Opstina_drzava_id",
                table: "Opstina",
                column: "drzava_id");

            migrationBuilder.CreateIndex(
                name: "IX_PitanjeOdgovor_ponudjeniOdgovor_id",
                table: "PitanjeOdgovor",
                column: "ponudjeniOdgovor_id");

            migrationBuilder.CreateIndex(
                name: "IX_PitanjeOdgovor_posaoPitanje_id",
                table: "PitanjeOdgovor",
                column: "posaoPitanje_id");

            migrationBuilder.CreateIndex(
                name: "IX_PonudjeniOdgovor_pitanje_id",
                table: "PonudjeniOdgovor",
                column: "pitanje_id");

            migrationBuilder.CreateIndex(
                name: "IX_Posao_opstina_id",
                table: "Posao",
                column: "opstina_id");

            migrationBuilder.CreateIndex(
                name: "IX_Posao_posaoTip_id",
                table: "Posao",
                column: "posaoTip_id");

            migrationBuilder.CreateIndex(
                name: "IX_Posao_poslodavac_id",
                table: "Posao",
                column: "poslodavac_id");

            migrationBuilder.CreateIndex(
                name: "IX_PosaoPitanje_pitanje_id",
                table: "PosaoPitanje",
                column: "pitanje_id");

            migrationBuilder.CreateIndex(
                name: "IX_PosaoPitanje_posao_id",
                table: "PosaoPitanje",
                column: "posao_id");

            migrationBuilder.CreateIndex(
                name: "IX_Preporuka_opstina_id",
                table: "Preporuka",
                column: "opstina_id");

            migrationBuilder.CreateIndex(
                name: "IX_PreporukaTipPosla_posaoTip_id",
                table: "PreporukaTipPosla",
                column: "posaoTip_id");

            migrationBuilder.CreateIndex(
                name: "IX_PreporukaTipPosla_preporuka_id",
                table: "PreporukaTipPosla",
                column: "preporuka_id");

            migrationBuilder.CreateIndex(
                name: "IX_SpremljeniPosao_aplikant_id",
                table: "SpremljeniPosao",
                column: "aplikant_id");

            migrationBuilder.CreateIndex(
                name: "IX_SpremljeniPosao_posao_id",
                table: "SpremljeniPosao",
                column: "posao_id");

            migrationBuilder.CreateIndex(
                name: "IX_verifikacijaEmail_korisnik_id",
                table: "verifikacijaEmail",
                column: "korisnik_id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "aplikantPosaoTip");

            migrationBuilder.DropTable(
                name: "Ocjena");

            migrationBuilder.DropTable(
                name: "PitanjeOdgovor");

            migrationBuilder.DropTable(
                name: "PreporukaTipPosla");

            migrationBuilder.DropTable(
                name: "SpremljeniPosao");

            migrationBuilder.DropTable(
                name: "verifikacijaEmail");

            migrationBuilder.DropTable(
                name: "ApliciraniPosao");

            migrationBuilder.DropTable(
                name: "PonudjeniOdgovor");

            migrationBuilder.DropTable(
                name: "PosaoPitanje");

            migrationBuilder.DropTable(
                name: "Aplikant");

            migrationBuilder.DropTable(
                name: "Pitanje");

            migrationBuilder.DropTable(
                name: "Posao");

            migrationBuilder.DropTable(
                name: "Preporuka");

            migrationBuilder.DropTable(
                name: "PosaoTip");

            migrationBuilder.DropTable(
                name: "Poslodavac");

            migrationBuilder.DropTable(
                name: "Opstina");

            migrationBuilder.DropTable(
                name: "KorisnickiNalog");

            migrationBuilder.DropTable(
                name: "Drzava");
        }
    }
}
