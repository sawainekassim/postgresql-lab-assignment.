-- WARNING: This test renames student id 1 and deletes student id 3.
-- Run only if those changes are intended for your lab data.

BEGIN;

UPDATE students
SET name = 'Kofi M.'
WHERE id = 1;

DELETE FROM students
WHERE id = 3;

SELECT
    tbl,
    op,
    old_row ->> 'name' AS was,
    new_row ->> 'name' AS now,
    changed_by,
    at
FROM audit_log
ORDER BY id DESC
LIMIT 10;

COMMIT;
