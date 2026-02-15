-- =========================
-- SCHEMA
-- =========================
CREATE SCHEMA IF NOT EXISTS library;
SET search_path = library;

-- =========================
-- CLANOVI
-- =========================
CREATE TABLE clan (
  clan_id           BIGSERIAL PRIMARY KEY,
  broj_karte        VARCHAR(20) NOT NULL UNIQUE,
  ime               VARCHAR(50) NOT NULL,
  prezime           VARCHAR(50) NOT NULL,
  email             VARCHAR(100) NOT NULL UNIQUE,
  telefon           VARCHAR(30),
  datum_uclanjenja  DATE NOT NULL,
  status            VARCHAR(15) NOT NULL
                     CHECK (status IN ('AKTIVAN','NEAKTIVAN','BLOKIRAN'))
);

-- =========================
-- ZAPOSLENI
-- =========================
CREATE TABLE zaposleni (
  zaposleni_id      BIGSERIAL PRIMARY KEY,
  ime               VARCHAR(50) NOT NULL,
  prezime           VARCHAR(50) NOT NULL,
  email             VARCHAR(100) NOT NULL UNIQUE,
  pozicija          VARCHAR(50) NOT NULL,
  datum_zaposlenja  DATE NOT NULL
);

-- =========================
-- KATALOG
-- =========================
CREATE TABLE izdavac (
  izdavac_id        BIGSERIAL PRIMARY KEY,
  naziv             VARCHAR(100) NOT NULL UNIQUE,
  drzava            VARCHAR(50) NOT NULL
);

CREATE TABLE kategorija (
  kategorija_id     BIGSERIAL PRIMARY KEY,
  naziv             VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE autor (
  autor_id          BIGSERIAL PRIMARY KEY,
  ime               VARCHAR(50) NOT NULL,
  prezime           VARCHAR(50) NOT NULL,
  datum_rodjenja    DATE
);

CREATE TABLE knjiga (
  knjiga_id         BIGSERIAL PRIMARY KEY,
  broj_knjige       VARCHAR(20) NOT NULL UNIQUE,
  naslov            VARCHAR(200) NOT NULL,
  godina_izdanja    INT NOT NULL CHECK (godina_izdanja > 0),
  jezik             VARCHAR(30) NOT NULL,
  izdavac_id        BIGINT NOT NULL,
  kategorija_id     BIGINT NOT NULL,
  CONSTRAINT fk_knjiga_izdavac
    FOREIGN KEY (izdavac_id)
    REFERENCES izdavac(izdavac_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_knjiga_kategorija
    FOREIGN KEY (kategorija_id)
    REFERENCES kategorija(kategorija_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

CREATE TABLE knjiga_autor (
  knjiga_id         BIGINT NOT NULL,
  autor_id          BIGINT NOT NULL,
  PRIMARY KEY (knjiga_id, autor_id),
  CONSTRAINT fk_ka_knjiga
    FOREIGN KEY (knjiga_id)
    REFERENCES knjiga(knjiga_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_ka_autor
    FOREIGN KEY (autor_id)
    REFERENCES autor(autor_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);

-- =========================
-- LOKACIJE I PRIMJERCI
-- =========================
CREATE TABLE filijala (
  filijala_id       BIGSERIAL PRIMARY KEY,
  naziv             VARCHAR(100) NOT NULL,
  adresa            VARCHAR(200) NOT NULL
);

CREATE TABLE polica (
  polica_id         BIGSERIAL PRIMARY KEY,
  filijala_id       BIGINT NOT NULL,
  oznaka            VARCHAR(20) NOT NULL,
  CONSTRAINT fk_polica_filijala
    FOREIGN KEY (filijala_id)
    REFERENCES filijala(filijala_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT uq_polica UNIQUE (filijala_id, oznaka)
);

CREATE TABLE primjerak (
  primjerak_id      BIGSERIAL PRIMARY KEY,
  knjiga_id         BIGINT NOT NULL,
  inventarski_broj  VARCHAR(30) NOT NULL UNIQUE,
  filijala_id       BIGINT NOT NULL,
  polica_id         BIGINT,
  status            VARCHAR(15) NOT NULL
                     CHECK (status IN ('DOSTUPNO','IZDATO','OTPISANO')),
  CONSTRAINT fk_primjerak_knjiga
    FOREIGN KEY (knjiga_id)
    REFERENCES knjiga(knjiga_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_primjerak_filijala
    FOREIGN KEY (filijala_id)
    REFERENCES filijala(filijala_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_primjerak_polica
    FOREIGN KEY (polica_id)
    REFERENCES polica(polica_id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
);

-- =========================
-- POZAJMICE
-- =========================
CREATE TABLE pozajmica (
  pozajmica_id      BIGSERIAL PRIMARY KEY,
  clan_id           BIGINT NOT NULL,
  zaposleni_id      BIGINT NOT NULL,
  datum_izdavanja   DATE NOT NULL,
  rok_vracanja      DATE NOT NULL,
  datum_vracanja    DATE,
  status            VARCHAR(15) NOT NULL
                     CHECK (status IN ('AKTIVNA','ZATVORENA','PREKORACENA')),
  CONSTRAINT fk_pozajmica_clan
    FOREIGN KEY (clan_id)
    REFERENCES clan(clan_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT fk_pozajmica_zaposleni
    FOREIGN KEY (zaposleni_id)
    REFERENCES zaposleni(zaposleni_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT chk_datum CHECK (rok_vracanja >= datum_izdavanja)
);

CREATE TABLE pozajmica_stavka (
  pozajmica_id      BIGINT NOT NULL,
  primjerak_id      BIGINT NOT NULL,
  datum_vracanja_stavke DATE,
  PRIMARY KEY (pozajmica_id, primjerak_id),
  CONSTRAINT fk_ps_pozajmica
    FOREIGN KEY (pozajmica_id)
    REFERENCES pozajmica(pozajmica_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_ps_primjerak
    FOREIGN KEY (primjerak_id)
    REFERENCES primjerak(primjerak_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);

-- =========================
-- REZERVACIJE
-- =========================
CREATE TABLE rezervacija (
  rezervacija_id    BIGSERIAL PRIMARY KEY,
  clan_id           BIGINT NOT NULL,
  knjiga_id         BIGINT NOT NULL,
  datum_rezervacije DATE NOT NULL,
  datum_isteka      DATE NOT NULL,
  status            VARCHAR(15) NOT NULL
                     CHECK (status IN ('AKTIVNA','OTKAZANA','ISTEKLA','REALIZOVANA')),
  CONSTRAINT fk_rez_clan
    FOREIGN KEY (clan_id)
    REFERENCES clan(clan_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_rez_knjiga
    FOREIGN KEY (knjiga_id)
    REFERENCES knjiga(knjiga_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT chk_rez_datumi CHECK (datum_isteka > datum_rezervacije)
);

-- =========================
-- KAZNE
-- =========================
CREATE TABLE kazna (
  kazna_id          BIGSERIAL PRIMARY KEY,
  pozajmica_id      BIGINT NOT NULL UNIQUE,
  iznos             NUMERIC(10,2) NOT NULL CHECK (iznos >= 0),
  datum_obracuna    DATE NOT NULL,
  placeno           BOOLEAN NOT NULL,
  napomena          TEXT,
  CONSTRAINT fk_kazna_pozajmica
    FOREIGN KEY (pozajmica_id)
    REFERENCES pozajmica(pozajmica_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
