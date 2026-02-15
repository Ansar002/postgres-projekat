SET search_path = library;



DROP INDEX IF EXISTS idx_pozajmica_datum_izdavanja;


-- prije indeksa
EXPLAIN ANALYZE
SELECT *
FROM pozajmica
WHERE datum_izdavanja BETWEEN '2024-01-01' AND '2024-01-31';


-- KREIRANJE INDEKSA
CREATE INDEX idx_pozajmica_datum_izdavanja
ON pozajmica (datum_izdavanja);


-- poslije indeksa
EXPLAIN ANALYZE
SELECT *
FROM pozajmica
WHERE datum_izdavanja BETWEEN '2024-01-01' AND '2024-01-31';
