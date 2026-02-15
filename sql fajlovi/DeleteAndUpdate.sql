SET search_path = library;

-- 1. IZMJENA PODATAKA (UPDATE)

-- SCENARIO: Član produžava članstvo / aktivira nalog

UPDATE clan
SET status = 'AKTIVAN'
WHERE broj_karte = 'C006';

-- SCENARIO: Produženje roka vraćanja pozajmice

UPDATE pozajmica
SET rok_vracanja = rok_vracanja + INTERVAL '7 days'
WHERE pozajmica_id = 1;

-- SCENARIO: Vraćen primjerak knjige
-- ŠTA RADIMO: Primjerak ID=2 se vraća u biblioteku:
--  1) u tabeli pozajmica_stavka upisujemo datum vraćanja stavke
--  2) u tabeli primjerak vraćamo status na 'DOSTUPNO'
UPDATE pozajmica_stavka
SET datum_vracanja_stavke = CURRENT_DATE
WHERE pozajmica_id = 1 AND primjerak_id = 2;

UPDATE primjerak
SET status = 'DOSTUPNO'
WHERE primjerak_id = 2;


-- 2. BRISANJE PODATAKA (DELETE)


-- SCENARIO: Čišćenje isteklih rezervacija
DELETE FROM rezervacija
WHERE status = 'ISTEKLA';

-- SCENARIO: Brisanje pozajmice (test podaci)
DELETE FROM pozajmica
WHERE pozajmica_id = 3;


-- 3. PREGLED I FILTRIRANJE PODATAKA (SELECT)

-- PRIMJER 1: Osnovno filtriranje (WHERE + OR)
-- CILJ: Pronaći sve članove koji su BLOKIRANI ili NEAKTIVNI.
SELECT
    clan_id,
    broj_karte,
    ime,
    prezime,
    email,
    status
FROM clan
WHERE status = 'BLOKIRAN'
   OR status = 'NEAKTIVAN';

-- PRIMJER 2: JOIN + filtriranje po statusu (aktivne pozajmice)
-- CILJ: Prikazati sve AKTIVNE pozajmice sa imenom člana i zaposlenog.
SELECT
    p.pozajmica_id,
    c.broj_karte,
    c.ime || ' ' || c.prezime AS clan,
    z.ime || ' ' || z.prezime AS zaposleni,
    p.datum_izdavanja,
    p.rok_vracanja,
    p.status
FROM pozajmica p
JOIN clan c ON p.clan_id = c.clan_id
JOIN zaposleni z ON p.zaposleni_id = z.zaposleni_id
WHERE p.status = 'AKTIVNA';

-- PRIMJER 3: LIKE + filtriranje po jeziku i naslovu
-- CILJ: Pronaći sve knjige na engleskom jeziku čiji naslov počinje slovom 'C'.
SELECT
    k.knjiga_id,
    k.broj_knjige,
    k.naslov,
    k.jezik,
    k.godina_izdanja
FROM knjiga k
WHERE k.jezik = 'Engleski'
  AND k.naslov LIKE 'C%';

-- PRIMJER 4: Agregacija (GROUP BY, HAVING, ORDER BY)
-- CILJ: Prikazati koliko je primjeraka svake knjige dostupno u bazi,
--       ali samo za knjige koje imaju bar 2 primjerka ukupno.
SELECT
    k.naslov,
    COUNT(pr.primjerak_id) AS ukupno_primjeraka,
    SUM(CASE WHEN pr.status = 'DOSTUPNO' THEN 1 ELSE 0 END) AS dostupno
FROM knjiga k
JOIN primjerak pr ON pr.knjiga_id = k.knjiga_id
GROUP BY k.knjiga_id, k.naslov
HAVING COUNT(pr.primjerak_id) >= 2
ORDER BY ukupno_primjeraka DESC;

-- PRIMJER 5: Podupit (Subquery)
-- CILJ: Pronaći sve knjige koje NIKADA nijesu bile pozajmljene.

SELECT
    k.knjiga_id,
    k.broj_knjige,
    k.naslov
FROM knjiga k
WHERE k.knjiga_id NOT IN (
    SELECT DISTINCT pr.knjiga_id
    FROM pozajmica_stavka ps
    JOIN primjerak pr ON ps.primjerak_id = pr.primjerak_id
);


