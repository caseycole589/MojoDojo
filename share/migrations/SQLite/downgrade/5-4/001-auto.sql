-- Convert schema '/home/casey/mojo/moblo/share/migrations/_source/deploy/5/001-auto.yml' to '/home/casey/mojo/moblo/share/migrations/_source/deploy/4/001-auto.yml':;

;
BEGIN;

;
CREATE TEMPORARY TABLE companys_temp_alter (
  id INTEGER PRIMARY KEY NOT NULL,
  name text NOT NULL
);

;
INSERT INTO companys_temp_alter( id, name) SELECT id, name FROM companys;

;
DROP TABLE companys;

;
CREATE TABLE companys (
  id INTEGER PRIMARY KEY NOT NULL,
  name text NOT NULL
);

;
CREATE UNIQUE INDEX companys_name02 ON companys (name);

;
INSERT INTO companys SELECT id, name FROM companys_temp_alter;

;
DROP TABLE companys_temp_alter;

;

COMMIT;

