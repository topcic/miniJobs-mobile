# MiniJobs Platforma

MiniJobs je platforma koja povezuje poslodavce i aplikante, omogućavajući brzo postavljanje poslova i jednostavno apliciranje. Sastoji se od:

- **Mobilne aplikacije** (za poslodavce i aplikante)
- **Desktop aplikacije** (za administraciju i upravljanje)

---

## 🚀 Ključne funkcionalnosti

- **Poslodavci**: Kreiranje, uređivanje i upravljanje poslovima, uključujući pregled i upravljanje aplikantima.
- **Aplikanti**: Pretraživanje poslova, apliciranje i ocjenjivanje poslodavaca za završene poslove.
- **Admin panel**: Upravljanje korisnicima i poslovima.

---

## 📋 Proces upravljanja poslovima

### 1. Kreiranje posla
1. **Unos osnovnih informacija**: Naziv, opis posla, itd.
2. **Definisanje detalja**: Tip posla, rok za apliciranje, itd.
3. **Način plaćanja**: Odabir metode plaćanja.
4. **Pregled i objava**: Provera unosa i objavljivanje posla.

### 2. Uređivanje posla
- Posao se može uređivati dok je u statusu:
  - **Kreiran**
  - **Aktivan**
- **Napomena**: Uređivanje nije moguće ako je posao u statusu **Obrisan**, **Aplikacije završene** ili **Završen**.

### 3. Brisanje posla
- Posao se može obrisati samo ako je u statusu:
  - **Kreiran**
  - **Aktivan**

### 4. Statusi posla

#### **Aktivan**
- Aplikanti mogu aplicirati na posao.
- Prelaz u status **Aplikacije završene** na dva načina:
  - **Automatski**: Kada istekne vrijeme za apliciranje (definisan rok).
  - **Ručno**: Poslodavac prebacuje posao u ovaj status ako:
    - Postoji barem jedan aplikant.
    - Poslodavac je dogovorio posao s aplikantom.

#### **Aplikacije završene**
- Poslodavac može:
  - Prihvatiti ili odbiti aplikante.
- Posao prelazi u status **Završen** u sljedećim slučajevima:
  - Niko se nije prijavio, a vrijeme je isteklo.
  - Poslodavac je prihvatio barem jednog aplikanta.

#### **Završen**
- Ako je aplikacija odobrena:
  - Poslodavac može ocijeniti odobrenog aplikanta.
  - Aplikant može ocijeniti poslodavca (vidjeti *Upravljanje aplikantima* i *Pregled poslova aplikanta*).

### 5. Meni posla
- Kada poslodavac pregleda svoje poslove, svaki posao ima svoj meni sa akcijama koje zavise od statusa posla.
- **Detalji posla**: Uvijek su prikazani.
- **Akcije u meniju** (u zavisnosti od statusa):
  - **Obriši**: Dostupno za poslove u statusu **Kreiran** ili **Aktivan**.
  - **Završi aplikacije**: Dostupno za poslove u statusu **Aktivan** ako postoji barem jedan aplikant.
  - **Završi posao**: Dostupno za poslove u statusu **Aplikacije završene** ako je barem jedan aplikant prihvaćen alebo ako niko nije aplicirao, a vrijeme je isteklo.

### 6. Upravljanje aplikantima
- **Prikaz aplikanta**:
  - Aplikanti su prikazani samo ako postoje kandidati koji su aplicirali na posao.
  - Klikom na opciju "Aplikanti" otvara se prikaz sa listom svih aplikanta koji su aplicirali.
  - Poslodavac može pregledati profile aplikanta.
- **Akcije nad aplikantima** (u zavisnosti od statusa posla):
  - **Status Aplikacije završene**:
    - Poslodavac može **odobriti** ili **odbiti** svakog aplikanta.
  - **Status Završen**:
    - Ako je aplikant odobren, poslodavac može **ocijeniti** aplikanta.

### 7. Pregled poslova aplikanta
- Kada aplikant pregleda svoje poslove, za poslove u statusu **Završen** gdje je aplikant odobren:
  - Aplikant ima opciju da **ocjeni poslodavca**.

---

## 📲 Prijava u sistem

Koristite sljedeće testne naloge za prijavu:

### Admin aplikacija
- **Email**: `admin@minijobs.ba`
- **Lozinka**: `Minijobs1234!`

### Aplikant (mobilna aplikacija)
- **Email**: `applicant@minijobs.ba`
- **Lozinka**: `Minijobs1234!`

### Poslodavac (mobilna aplikacija)
- **Email**: `employer@minijobs.ba`
- **Lozinka**: `Minijobs1234!`
