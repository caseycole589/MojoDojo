-- Convert schema '/home/casey/MojoDojo/share/migrations/_source/deploy/6/001-auto.yml' to '/home/casey/MojoDojo/share/migrations/_source/deploy/7/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE bills ADD COLUMN amount decimal(9,2) NOT NULL;

;
CREATE TEMPORARY TABLE users_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL,
  user_id integer NOT NULL,
  firstname text NOT NULL,
  lastname text NOT NULL,
  email text NOT NULL,
  company_name text NOT NULL,
  date_sent datetime NOT NULL,
  template text NOT NULL
);

;
INSERT INTO users_temp_alter( id, firstname, lastname, email) SELECT id, firstname, lastname, email FROM users;

;
DROP TABLE users;

;
CREATE TABLE users (
  id INTEGER PRIMARY KEY NOT NULL,
  user_id integer NOT NULL,
  firstname text NOT NULL,
  lastname text NOT NULL,
  email text NOT NULL,
  company_name text NOT NULL,
  date_sent datetime NOT NULL,
  template text NOT NULL
);

;
INSERT INTO users SELECT id, user_id, firstname, lastname, email, company_name, date_sent, template FROM users_temp_alter;

;
DROP TABLE users_temp_alter;

;

COMMIT;

