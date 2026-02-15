
REVOKE ALL ON SCHEMA library FROM PUBLIC;


-- 1) KREIRANJE ULOGA (ROLES) - grupe bez logovanja

CREATE ROLE library_clerk WITH NOLOGIN;     -- bibliotekar/šalter
CREATE ROLE library_manager WITH NOLOGIN;   -- upravnik


-- 2) DODJELJIVANJE PRAVA NA ŠEMU

GRANT USAGE ON SCHEMA library TO library_clerk;
GRANT USAGE ON SCHEMA library TO library_manager;


-- 3) PRAVA ZA BIBLIOTEKARA (library_clerk)
--    - može da čita šifarnike i knjige
--    - može da upisuje/azurira pozajmice i rezervacije
--    - ne može da briše knjige i primjerke


GRANT SELECT ON TABLE
    library.knjiga,
    library.autor,
    library.knjiga_autor,
    library.izdavac,
    library.kategorija,
    library.primjerak,
    library.clan
TO library_clerk;


GRANT SELECT, INSERT, UPDATE ON TABLE
    library.pozajmica,
    library.pozajmica_stavka,
    library.rezervacija
TO library_clerk;


GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA library TO library_clerk;

REVOKE DELETE ON TABLE library.knjiga FROM library_clerk;
REVOKE DELETE ON TABLE library.primjerak FROM library_clerk;

-- 4) PRAVA ZA MENADŽERA (library_manager)
--    - vidi sve
--    - može da mijenja šifarnike (knjige, autore, primjerke, police...)


GRANT SELECT ON ALL TABLES IN SCHEMA library TO library_manager;
GRANT INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA library TO library_manager;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA library TO library_manager;


-- 5) KREIRANJE KORISNIKA (USERS)

CREATE USER ana_clerk WITH PASSWORD 'clerk123';
CREATE USER marko_manager WITH PASSWORD 'manager123';


-- 6) POVEZIVANJE KORISNIKA SA ULOGAMA

GRANT library_clerk TO ana_clerk;
GRANT library_manager TO marko_manager;
