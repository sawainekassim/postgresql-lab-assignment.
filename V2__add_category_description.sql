-- V2: Add an optional description to categories.
ALTER TABLE categories
ADD COLUMN description TEXT;
