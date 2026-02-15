SET search_path = library;


-- TRIGER 1: Poslovno pravilo
-- Zabranjuje izdavanje primjerka ako nije dostupan


CREATE OR REPLACE FUNCTION f_check_primjerak_dostupan()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_status VARCHAR(15);
BEGIN
    SELECT status
    INTO v_status
    FROM primjerak
    WHERE primjerak_id = NEW.primjerak_id;

    IF v_status IS NULL THEN
        RAISE EXCEPTION 'Primjerak % ne postoji.', NEW.primjerak_id;
    END IF;

    IF v_status <> 'DOSTUPNO' THEN
        RAISE EXCEPTION 'Primjerak % nije dostupan (status=%).', NEW.primjerak_id, v_status;
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_check_primjerak_dostupan
BEFORE INSERT ON pozajmica_stavka
FOR EACH ROW
EXECUTE FUNCTION f_check_primjerak_dostupan();



-- TRIGER 2: Automatsko održavanje integriteta
-- Kad se doda stavka pozajmice -> primjerak postaje IZDATO
-- Kad se upiše datum vraćanja -> primjerak postaje DOSTUPNO

CREATE OR REPLACE FUNCTION f_sync_status_primjerka()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    
    IF TG_OP = 'INSERT' THEN
        UPDATE primjerak
        SET status = 'IZDATO'
        WHERE primjerak_id = NEW.primjerak_id;

        RETURN NEW;
    END IF;


    IF TG_OP = 'UPDATE' THEN
        IF OLD.datum_vracanja_stavke IS NULL
           AND NEW.datum_vracanja_stavke IS NOT NULL THEN

            UPDATE primjerak
            SET status = 'DOSTUPNO'
            WHERE primjerak_id = NEW.primjerak_id;
        END IF;

        RETURN NEW;
    END IF;

    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_sync_status_primjerka
AFTER INSERT OR UPDATE ON pozajmica_stavka
FOR EACH ROW
EXECUTE FUNCTION f_sync_status_primjerka();
