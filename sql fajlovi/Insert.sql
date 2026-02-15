SET search_path = library;

-- =========================
-- CLANOVI (10)
-- =========================
INSERT INTO clan (broj_karte, ime, prezime, email, telefon, datum_uclanjenja, status) VALUES
('C001','Marko','Petrovic','marko.petrovic@mail.com','069111111','2023-01-10','AKTIVAN'),
('C002','Ana','Jovanovic','ana.jovanovic@mail.com','069222222','2023-02-12','AKTIVAN'),
('C003','Ivan','Nikolic','ivan.nikolic@mail.com','069333333','2023-03-15','AKTIVAN'),
('C004','Milica','Kovacevic','milica.k@mail.com','069444444','2023-04-01','AKTIVAN'),
('C005','Stefan','Ilic','stefan.ilic@mail.com','069555555','2023-04-20','AKTIVAN'),
('C006','Jelena','Radovic','jelena.radovic@mail.com','069666666','2023-05-10','NEAKTIVAN'),
('C007','Nikola','Vukovic','nikola.vukovic@mail.com','069777777','2023-06-01','AKTIVAN'),
('C008','Sara','Popovic','sara.popovic@mail.com','069888888','2023-06-15','AKTIVAN'),
('C009','Luka','Markovic','luka.markovic@mail.com','069999999','2023-07-01','BLOKIRAN'),
('C010','Marija','Stojanovic','marija.s@mail.com','068123123','2023-07-20','AKTIVAN');

-- =========================
-- ZAPOSLENI (5)
-- =========================
INSERT INTO zaposleni (ime, prezime, email, pozicija, datum_zaposlenja) VALUES
('Petar','Simic','petar.simic@library.com','Bibliotekar','2020-01-10'),
('Ivana','Djuric','ivana.djuric@library.com','Bibliotekar','2021-03-15'),
('Milan','Jankovic','milan.j@library.com','Menadzer','2019-05-20'),
('Sanja','Kostic','sanja.k@library.com','Bibliotekar','2022-02-01'),
('Dragan','Tomic','dragan.t@library.com','Administrator','2018-09-10');

-- =========================
-- IZDAVACI (5)
-- =========================
INSERT INTO izdavac (naziv, drzava) VALUES
('Laguna','Srbija'),
('Vulkan','Srbija'),
('Penguin Books','UK'),
('HarperCollins','USA'),
('Oxford Press','UK');

-- =========================
-- KATEGORIJE (5)
-- =========================
INSERT INTO kategorija (naziv) VALUES
('Roman'),
('Nauka'),
('IT'),
('Istorija'),
('Psihologija');

-- =========================
-- AUTORI (6)
-- =========================
INSERT INTO autor (ime, prezime, datum_rodjenja) VALUES
('Ivo','Andric','1892-10-09'),
('Mesa','Selimovic','1910-04-26'),
('George','Orwell','1903-06-25'),
('Yuval','Harari','1976-02-24'),
('Robert','Martin','1952-12-05'),
('Daniel','Kahneman','1934-03-05');

-- =========================
-- KNJIGE (6)
-- =========================
INSERT INTO knjiga (broj_knjige, naslov, godina_izdanja, jezik, izdavac_id, kategorija_id) VALUES
('BK001','Na Drini cuprija',1945,'Srpski',1,1),
('BK002','Dervis i smrt',1966,'Srpski',1,1),
('BK003','1984',1949,'Engleski',3,1),
('BK004','Sapiens',2011,'Engleski',4,2),
('BK005','Clean Code',2008,'Engleski',5,3),
('BK006','Thinking, Fast and Slow',2011,'Engleski',4,5);

-- =========================
-- KNJIGA_AUTOR (N:M)
-- =========================
INSERT INTO knjiga_autor (knjiga_id, autor_id) VALUES
(1,1),
(2,2),
(3,3),
(4,4),
(5,5),
(6,6);

-- =========================
-- FILIJALE (3)
-- =========================
INSERT INTO filijala (naziv, adresa) VALUES
('Centralna biblioteka','Njegoseva 10'),
('Gradska biblioteka','Bulevar slobode 25'),
('Studentska biblioteka','Univerzitetska bb');

-- =========================
-- POLICE (5)
-- =========================
INSERT INTO polica (filijala_id, oznaka) VALUES
(1,'A1'),
(1,'A2'),
(2,'B1'),
(2,'B2'),
(3,'C1');

-- =========================
-- PRIMJERCI (8)
-- =========================
INSERT INTO primjerak (knjiga_id, inventarski_broj, filijala_id, polica_id, status) VALUES
(1,'INV001',1,1,'DOSTUPNO'),
(1,'INV002',1,2,'IZDATO'),
(2,'INV003',1,1,'DOSTUPNO'),
(3,'INV004',2,3,'DOSTUPNO'),
(4,'INV005',2,4,'DOSTUPNO'),
(5,'INV006',3,5,'DOSTUPNO'),
(6,'INV007',3,NULL,'DOSTUPNO'),
(3,'INV008',2,3,'IZDATO');

-- =========================
-- POZAJMICE (3)
-- =========================
INSERT INTO pozajmica (clan_id, zaposleni_id, datum_izdavanja, rok_vracanja, status) VALUES
(1,1,'2024-01-10','2024-01-25','AKTIVNA'),
(2,2,'2024-01-05','2024-01-20','PREKORACENA'),
(3,1,'2024-01-01','2024-01-15','ZATVORENA');

-- =========================
-- POZAJMICA_STAVKA
-- =========================
INSERT INTO pozajmica_stavka (pozajmica_id, primjerak_id) VALUES
(1,2),
(2,8),
(3,1);

-- =========================
-- REZERVACIJE (3)
-- =========================
INSERT INTO rezervacija (clan_id, knjiga_id, datum_rezervacije, datum_isteka, status) VALUES
(4,1,'2024-01-10','2024-01-20','AKTIVNA'),
(5,3,'2024-01-12','2024-01-22','AKTIVNA'),
(6,4,'2024-01-05','2024-01-15','ISTEKLA');

-- =========================
-- KAZNE (1)
-- =========================
INSERT INTO kazna (pozajmica_id, iznos, datum_obracuna, placeno, napomena) VALUES
(2,15.00,'2024-01-21',FALSE,'Kasnjenje 6 dana');
