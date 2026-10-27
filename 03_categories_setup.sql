-- Part 2: Self-referencing category hierarchy

CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    parent_id INT REFERENCES categories(id),
    CONSTRAINT categories_not_own_parent
        CHECK (parent_id IS DISTINCT FROM id)
);

INSERT INTO categories (name, parent_id)
VALUES ('Electronics', NULL);

INSERT INTO categories (name, parent_id)
SELECT 'Computers', id
FROM categories
WHERE name = 'Electronics';

INSERT INTO categories (name, parent_id)
SELECT 'Laptops', id
FROM categories
WHERE name = 'Computers';

INSERT INTO categories (name, parent_id)
SELECT 'Phones', id
FROM categories
WHERE name = 'Electronics';

SELECT id, name, parent_id
FROM categories
ORDER BY id;
