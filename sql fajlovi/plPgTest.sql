SET search_path = library;


-- 1) TEST FUNKCIJE: fn_izracunaj_kaznu
-- Pokušaj izračuna kazne za pozajmicu ID 2 (u našim podacima je bila PREKORACENA)
SELECT fn_izracunaj_kaznu(2) AS kazna_za_pozajmicu_2;

-- Provjera detalja pozajmice 
SELECT pozajmica_id, datum_izdavanja, rok_vracanja, datum_vracanja, status
FROM pozajmica
WHERE pozajmica_id = 2;


-- 2) TEST PROCEDURE: sp_produzi_rok

SELECT pozajmica_id, rok_vracanja, status
FROM pozajmica
WHERE pozajmica_id = 1;

-- Produži rok za 7 dana (pozajmica mora biti AKTIVNA)
CALL sp_produzi_rok(1, 7);

-- Pogledaj rok poslije
SELECT pozajmica_id, rok_vracanja, status
FROM pozajmica
WHERE pozajmica_id = 1;


-- 3) TEST KURSORA + EXCEPTION: sp_kursor_clanovi

CALL sp_kursor_clanovi();

