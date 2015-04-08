-- Convert schema '/home/casey/mojo/moblo/share/migrations/_source/deploy/3/001-auto.yml' to '/home/casey/mojo/moblo/share/migrations/_source/deploy/2/001-auto.yml':;

;
BEGIN;

;
CREATE TEMPORARY TABLE users_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL,
  pw_hash text NOT NULL,
  username text NOT NULL,
  firstname text NOT NULL,
  lastname text NOT NULL
);

;
INSERT INTO users_temp_alter( id, pw_hash, username, firstname, lastname) SELECT id, pw_hash, username, firstname, lastname FROM users;

;
DROP TABLE users;

;
CREATE TABLE users (
  id INTEGER PRIMARY KEY NOT NULL,
  pw_hash text NOT NULL,
  username text NOT NULL,
  firstname text NOT NULL,
  lastname text NOT NULL
);

;
CREATE UNIQUE INDEX users_username02 ON users (username);

;
INSERT INTO users SELECT id, pw_hash, username, firstname, lastname FROM users_temp_alter;

;
DROP TABLE users_temp_alter;

;
DROP TABLE companys;

;

COMMIT;

