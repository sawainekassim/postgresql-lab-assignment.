-- Verify the new column after Flyway V2 has been applied.

SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'categories'
ORDER BY ordinal_position;

SELECT id, name, parent_id, description
FROM categories
ORDER BY id;

-- This query assumes Flyway has created its history table in public.
SELECT installed_rank, version, description, type, success
FROM flyway_schema_history
ORDER BY installed_rank;
