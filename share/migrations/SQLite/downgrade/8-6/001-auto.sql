-- Convert schema '/home/casey/MojoDojo/share/migrations/_source/deploy/8/001-auto.yml' to '/home/casey/MojoDojo/share/migrations/_source/deploy/6/001-auto.yml':;

;
BEGIN;

;
CREATE TEMPORARY TABLE bills_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL,
  customer_name text NOT NULL,
  company_name text NOT NULL,
  date_published datetime NOT NULL DEFAULT (datetime('now')),
  is_payed int NOT NULL,
  FOREIGN KEY (customer_name) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (company_name) REFERENCES companys(id)
);

;
INSERT INTO bills_temp_alter( id, customer_name, company_name, date_published, is_payed) SELECT id, customer_name, company_name, date_published, is_payed FROM bills;

;
DROP TABLE bills;

;
CREATE TABLE bills (
  id INTEGER PRIMARY KEY NOT NULL,
  customer_name text NOT NULL,
  company_name text NOT NULL,
  date_published datetime NOT NULL DEFAULT (datetime('now')),
  is_payed int NOT NULL,
  FOREIGN KEY (customer_name) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (company_name) REFERENCES companys(id)
);

;
CREATE INDEX bills_idx_customer_name02 ON bills (customer_name);

;
CREATE INDEX bills_idx_company_name02 ON bills (company_name);

;
INSERT INTO bills SELECT id, customer_name, company_name, date_published, is_payed FROM bills_temp_alter;

;
DROP TABLE bills_temp_alter;

;
CREATE TEMPORARY TABLE users_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL,
  pw_hash text NOT NULL,
  username text NOT NULL,
  firstname text NOT NULL,
  lastname text NOT NULL,
  city text NOT NULL,
  zipcode integer NOT NULL,
  email text NOT NULL,
  company text NOT NULL,
  user_level text NOT NULL,
  FOREIGN KEY (company) REFERENCES companys(name)
);

;
INSERT INTO users_temp_alter( id, firstname, lastname, email) SELECT id, firstname, lastname, email FROM users;

;
DROP TABLE users;

;
CREATE TABLE users (
  id INTEGER PRIMARY KEY NOT NULL,
  pw_hash text NOT NULL,
  username text NOT NULL,
  firstname text NOT NULL,
  lastname text NOT NULL,
  city text NOT NULL,
  zipcode integer NOT NULL,
  email text NOT NULL,
  company text NOT NULL,
  user_level text NOT NULL,
  FOREIGN KEY (company) REFERENCES companys(name)
);

;
CREATE INDEX users_idx_company02 ON users (company);

;
CREATE UNIQUE INDEX users_username02 ON users (username);

;
INSERT INTO users SELECT id, pw_hash, username, firstname, lastname, city, zipcode, email, company, user_level FROM users_temp_alter;

;
DROP TABLE users_temp_alter;

;

COMMIT;

