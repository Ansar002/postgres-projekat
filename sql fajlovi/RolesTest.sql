SET search_path = library;



-- 1) Pretvaramo se da smo bibliotekar
SET ROLE library_clerk;

-- 2) POZITIVNI TEST (treba da uspije)
-- Bibliotekar smije da čita knjige
SELECT * FROM knjiga LIMIT 1;

-- 3) NEGATIVNI TEST (mora da PADNE)
-- Bibliotekar NE smije da briše knjige
DELETE FROM knjiga WHERE knjiga_id = 1;

-- 4) Vraćamo se na admina
RESET ROLE;



SET ROLE library_manager;

-- 5) POZITIVNI TEST (treba da uspije)
-- Menadžer ima puna prava
DELETE FROM knjiga
WHERE knjiga_id = 1;

RESET ROLE;
