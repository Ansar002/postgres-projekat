SET search_path = library;

-- 1) Provjera početnog stanja primjerka 
SELECT primjerak_id, status FROM primjerak WHERE primjerak_id = 1;

-- 2) Pokušaj izdavanja
INSERT INTO pozajmica_stavka (pozajmica_id, primjerak_id)
VALUES (1, 1);

SELECT primjerak_id, status FROM primjerak WHERE primjerak_id = 1;

-- 3) Pokušaj ponovnog izdavanja istog primjerka 
INSERT INTO pozajmica_stavka (pozajmica_id, primjerak_id)
VALUES (2, 1);

-- 4) Vraćanje stavke 
UPDATE pozajmica_stavka
SET datum_vracanja_stavke = CURRENT_DATE
WHERE pozajmica_id = 1 AND primjerak_id = 1;

SELECT primjerak_id, status FROM primjerak WHERE primjerak_id = 1;
