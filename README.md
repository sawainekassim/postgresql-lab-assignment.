# PostgreSQL Lab Assignment

## Title
**PostgreSQL Audit Logging, Recursive CTEs, and Flyway Database Migrations**

## Objective
This lab demonstrates:
1. Creating an audit table and trigger to record changes to a table.
2. Modeling a hierarchical category structure with a self-referencing foreign key.
3. Using a recursive common table expression (CTE) to display the hierarchy.
4. Using Flyway to baseline an existing schema and apply a versioned migration.

## Environment
- PostgreSQL 17.11
- SQL Shell (`psql`) on Windows
- Java 21
- Flyway Community Edition 13.11.1
- Database: `bootcamp`
- Database user: `postgres`

Do not publish your database password or any other secrets.

---

## Part 1 — Audit logging

### 1. Create the audit table, trigger function, and trigger

File: `scripts/01_audit_setup.sql`

The `audit_log` table stores the affected table, operation type, old row, new row, database user, and timestamp. The trigger function converts row values to JSONB. For `UPDATE`, both old and new values are stored; for `DELETE`, the old row is stored; for `INSERT`, the new row is stored.

### 2. Test the audit trigger

File: `scripts/02_audit_test.sql`

In the completed lab, student ID 1 was renamed from `Alice` to `Kofi M.` and student ID 3 (`Carol`) was deleted. The audit query showed an `UPDATE` entry and a `DELETE` entry, with `postgres` as the user. The transaction was committed.

**Note:** This test script changes and deletes those sample rows. Run it only in your lab database and only if you intend to make those changes.

### Expected result
The audit log should include entries for the update and delete. The update entry contains the previous and new names; the delete entry contains the deleted student's old name and a null new row.

---

## Part 2 — Hierarchical categories and recursive CTE

### 1. Create the categories table

File: `scripts/03_categories_setup.sql`

The table contains:
- `id`: primary key
- `name`: category name
- `parent_id`: foreign key referencing another category
- A check constraint preventing a category from being its own direct parent

The sample data creates this hierarchy:

```text
Electronics
  Computers
    Laptops
  Phones
```

### 2. Display the hierarchy recursively

File: `scripts/04_recursive_category_tree.sql`

The recursive CTE starts with root categories (`parent_id IS NULL`) and repeatedly joins children to their parents. It tracks depth for indentation and an array path to avoid revisiting an ID in the same path.

### Observed category rows
| id | name | parent_id |
|---:|---|---:|
| 1 | Electronics | NULL |
| 2 | Computers | 1 |
| 3 | Laptops | 2 |
| 4 | Phones | 1 |

---

## Part 3 — Flyway migration

### 1. Configure Flyway

Flyway was configured to connect to the `bootcamp` database on `localhost:5432`, using the `postgres` account and the `sql` migration folder.

Example `flyway.toml` (keep this local; never store passwords in it):

```toml
[flyway]
locations = ["filesystem:sql"]

[environments.default]
url = "jdbc:postgresql://localhost:5432/bootcamp"
user = "postgres"
```

The password was supplied separately when running Flyway.

### 2. Baseline the existing database

Because the database already contained the `students`, `audit_log`, and `categories` tables, Flyway was baselined at version 1 rather than attempting to recreate the existing schema.

### 3. Apply version 2

File: `sql/V2__add_category_description.sql`

```sql
ALTER TABLE categories
ADD COLUMN description TEXT;
```

Flyway reported that it validated two migrations, applied one migration, and moved the schema to version `v2`.

### 4. Verify the result

The `categories` table retained its four rows, and the new `description` column was present. Existing descriptions were `NULL`, as expected, because the migration added the column without setting values.

Flyway `info` showed:
- Version 1 — `<< Flyway Baseline >>` — `Baseline`
- Version 2 — `add category description` — `Success`

The Flyway message about not being signed in was informational and did not prevent the migration from succeeding.

---

## Verification queries

Run `scripts/05_verification.sql` after the migration. It checks the category table's columns, category data, and Flyway history.

## Conclusion

This lab demonstrated PostgreSQL trigger-based auditing, hierarchical data modeling, recursive queries, and version-controlled schema changes using Flyway. The audit trigger recorded changes to student rows, the recursive CTE displayed the category hierarchy, and Flyway successfully applied version 2 to add the `description` column while preserving the existing category rows.

## Submission checklist
- [ ] Upload this repository to GitHub.
- [ ] Check that all SQL files and this README are present.
- [ ] Do not upload passwords, private connection details, or other secrets.
- [ ] Add screenshots of your own results if your instructor requires them.
- [ ] Submit your GitHub repository URL in the assignment portal.
