# 📚 PostgreSQL Database Project

## 📌 Opis projekta
Ovaj projekat predstavlja relacijsku bazu podataka razvijenu u PostgreSQL-u.
Baza modeluje sistem za upravljanje [Biblitoeke].
Projekat sadrži kreiranje tabela, indekse, transakcije, role, triggere i PL/pgSQL funkcije, kao i test fajlove za provjeru funkcionalnosti.

Projekat je kreiran i testiran u DBeaver okruženju koristeći PostgreSQL.

---

## 🛠 Tehnologije
- PostgreSQL
- DBeaver
- SQL

---

## 📂 Struktura projekta

sql/
├── Create.sql
├── Insert.sql
├── DeleteAndUpdate.sql
├── Index.sql
├── Roles.sql
├── RolesTest.sql
├── Transactions.sql
├── Trigger.sql
├── TriggerTest.sql
├── plPg.sql
├── plPgTest.sql


---

## 📑 Opis fajlova

- **Create.sql** – Kreiranje tabela i relacija (PRIMARY KEY, FOREIGN KEY)
- **Insert.sql** – Unos testnih podataka
- **DeleteAndUpdate.sql** – UPDATE i DELETE operacije
- **Index.sql** – Kreiranje indeksa
- **Roles.sql** – Definisanje korisničkih rola i privilegija
- **RolesTest.sql** – Testiranje rola
- **Transactions.sql** – Primjeri transakcija (BEGIN, COMMIT, ROLLBACK)
- **Trigger.sql** – Kreiranje triggera
- **TriggerTest.sql** – Testiranje triggera
- **plPg.sql** – PL/pgSQL funkcije i procedure
- **plPgTest.sql** – Testiranje funkcija/procedura

---

## 🚀 Pokretanje projekta

### 1️⃣ Kreiranje baze

```sql
CREATE DATABASE naziv_baze;

psql -U postgres -d naziv_baze -f sql/Create.sql
psql -U postgres -d naziv_baze -f sql/Insert.sql
psql -U postgres -d naziv_baze -f sql/Index.sql
psql -U postgres -d naziv_baze -f sql/Roles.sql
psql -U postgres -d naziv_baze -f sql/Trigger.sql
psql -U postgres -d naziv_baze -f sql/plPg.sql

test skripte
psql -U postgres -d naziv_baze -f sql/RolesTest.sql
psql -U postgres -d naziv_baze -f sql/TriggerTest.sql
psql -U postgres -d naziv_baze -f sql/plPgTest.sql



