SET search_path = library;


-- SCENARIO 1: USPJEŠNA TRANSAKCIJA (COMMIT)


BEGIN;

-- 1) Rezervacija knjige
INSERT INTO rezervacija (clan_id, knjiga_id, datum_rezervacije, datum_isteka, status)
VALUES (1, 1, CURRENT_DATE, CURRENT_DATE + 7, 'AKTIVNA');

-- 2) Upis kazne 
INSERT INTO kazna (pozajmica_id, iznos, datum_obracuna, placeno, napomena)
VALUES (1, 2.00, CURRENT_DATE, FALSE, 'Administrativna kazna (demo)');

COMMIT;

-- Provjera:
SELECT * FROM rezervacija ORDER BY rezervacija_id DESC LIMIT 1;
SELECT * FROM kazna WHERE pozajmica_id = 1 ORDER BY kazna_id DESC LIMIT 1;



-- SCENARIO 2: POTPUNO PONIŠTAVANJE (ROLLBACK)


BEGIN;

-- 1) Ispravna rezervacija 
INSERT INTO rezervacija (clan_id, knjiga_id, datum_rezervacije, datum_isteka, status)
VALUES (1, 1, CURRENT_DATE, CURRENT_DATE + 5, 'AKTIVNA');

-- 2) Namjerno greška: 
INSERT INTO kazna (pozajmica_id, iznos, datum_obracuna, placeno, napomena)
VALUES (1, -10.00, CURRENT_DATE, FALSE, 'Ovo treba da pukne');

ROLLBACK;

-- Provjera: 
SELECT * FROM rezervacija ORDER BY rezervacija_id DESC LIMIT 3;



-- SCENARIO 3: DJELIMIČNO PONIŠTAVANJE (SAVEPOINT)


BEGIN;

-- 1) Rezervacija 
INSERT INTO rezervacija (clan_id, knjiga_id, datum_rezervacije, datum_isteka, status)
VALUES (1, 1, CURRENT_DATE, CURRENT_DATE + 10, 'AKTIVNA');

SAVEPOINT sp_rezervacija_ok;

-- 2) Namjerno greška kazna 
INSERT INTO kazna (pozajmica_id, iznos, datum_obracuna, placeno, napomena)
VALUES (1, -5.00, CURRENT_DATE, FALSE, 'Greška - rollback do savepoint');

ROLLBACK TO SAVEPOINT sp_rezervacija_ok;

-- 4) Ispravna kazna
INSERT INTO kazna (pozajmica_id, iznos, datum_obracuna, placeno, napomena)
VALUES (1, 5.00, CURRENT_DATE, FALSE, 'Ispravno nakon savepoint');

COMMIT;

-- Provjera:
SELECT * FROM rezervacija ORDER BY rezervacija_id DESC LIMIT 3;
SELECT * FROM kazna WHERE pozajmica_id = 1 ORDER BY kazna_id DESC LIMIT 3;
