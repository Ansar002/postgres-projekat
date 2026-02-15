SET search_path = library;


-- 1) FUNKCIJA: Izračunavanje kazne za pozajmicu
-- Pokriva: IF, CASE, promjenljive, ugniježdene SELECT naredbe

CREATE OR REPLACE FUNCTION fn_izracunaj_kaznu(p_pozajmica_id BIGINT)
RETURNS NUMERIC(10,2)
LANGUAGE plpgsql
AS $$
DECLARE
    v_rok DATE;
    v_datum_vracanja DATE;
    v_dani_kasnjenja INT;
    v_iznos NUMERIC(10,2);
BEGIN
    SELECT rok_vracanja, COALESCE(datum_vracanja, CURRENT_DATE)
    INTO v_rok, v_datum_vracanja
    FROM pozajmica
    WHERE pozajmica_id = p_pozajmica_id;

    IF v_rok IS NULL THEN
        RAISE EXCEPTION 'Pozajmica % ne postoji.', p_pozajmica_id;
    END IF;

    v_dani_kasnjenja := v_datum_vracanja - v_rok;

    IF v_dani_kasnjenja <= 0 THEN
        RETURN 0;
    END IF;

    v_iznos :=
        CASE
            WHEN v_dani_kasnjenja BETWEEN 1 AND 3  THEN v_dani_kasnjenja * 1.00
            WHEN v_dani_kasnjenja BETWEEN 4 AND 10 THEN v_dani_kasnjenja * 1.50
            ELSE v_dani_kasnjenja * 2.00
        END;

    RETURN v_iznos;
END;
$$;


-- 2) PROCEDURA: Produži rok vraćanja pozajmice (IF + promjenljive + nested SQL)

CREATE OR REPLACE PROCEDURE sp_produzi_rok(
    p_pozajmica_id BIGINT,
    p_dani INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_status VARCHAR(15);
BEGIN

    SELECT status
    INTO v_status
    FROM pozajmica
    WHERE pozajmica_id = p_pozajmica_id;


    IF v_status IS NULL THEN
        RAISE EXCEPTION 'Pozajmica % ne postoji.', p_pozajmica_id;
    END IF;


    IF v_status <> 'AKTIVNA' THEN
        RAISE EXCEPTION 'Pozajmica % nije aktivna (status=%).', p_pozajmica_id, v_status;
    END IF;

    UPDATE pozajmica
    SET rok_vracanja = rok_vracanja + p_dani
    WHERE pozajmica_id = p_pozajmica_id;
END;
$$;


-- 3) PROCEDURA SA KURSOROM: Prođi kroz članove i ispiši status (KURSOR + EXCEPTION)

CREATE OR REPLACE PROCEDURE sp_kursor_clanovi()
LANGUAGE plpgsql
AS $$
DECLARE
    c_clan CURSOR FOR
        SELECT clan_id, broj_karte, status
        FROM clan;

    v_clan_id BIGINT;
    v_broj_karte VARCHAR(20);
    v_status VARCHAR(15);
BEGIN
    OPEN c_clan;

    LOOP
        FETCH c_clan INTO v_clan_id, v_broj_karte, v_status;
        EXIT WHEN NOT FOUND;

        BEGIN

            IF v_status IS NULL THEN
                RAISE EXCEPTION 'Status je NULL za clan_id=%', v_clan_id;
            END IF;

            RAISE NOTICE 'Clan ID=% (karte=%) status=%', v_clan_id, v_broj_karte, v_status;

        EXCEPTION
            WHEN OTHERS THEN

                RAISE NOTICE 'Greška pri obradi člana ID=% (preskočeno).', v_clan_id;
        END;
    END LOOP;

    CLOSE c_clan;
END;
$$;