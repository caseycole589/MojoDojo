-- Convert schema '/home/casey/mojo/moblo/share/migrations/_source/deploy/2/001-auto.yml' to '/home/casey/mojo/moblo/share/migrations/_source/deploy/3/001-auto.yml':;

;
BEGIN;

;
CREATE TABLE companys (
  id INTEGER PRIMARY KEY NOT NULL,
  name text NOT NULL
);

;
CREATE UNIQUE INDEX companys_name ON companys (name);

;
ALTER TABLE users ADD COLUMN city text NOT NULL;

;
ALTER TABLE users ADD COLUMN zipcode integer NOT NULL;

;
ALTER TABLE users ADD COLUMN email text NOT NULL;

;
ALTER TABLE users ADD COLUMN company text NOT NULL;

;
ALTER TABLE users ADD COLUMN user_level text NOT NULL;

;
CREATE INDEX users_idx_company ON users (company);

;

;

COMMIT;

