-- Convert schema '/home/casey/mojo/moblo/share/migrations/_source/deploy/4/001-auto.yml' to '/home/casey/mojo/moblo/share/migrations/_source/deploy/5/001-auto.yml':;

;
BEGIN;

;
CREATE TEMPORARY TABLE companys_temp_alter (
  id integer NOT NULL,
  name text NOT NULL,
  PRIMARY KEY (name)
);

;
INSERT INTO companys_temp_alter( id, name) SELECT id, name FROM companys;

;
DROP TABLE companys;

;
CREATE TABLE companys (
  id integer NOT NULL,
  name text NOT NULL,
  PRIMARY KEY (name)
);

;
INSERT INTO companys SELECT id, name FROM companys_temp_alter;

;
DROP TABLE companys_temp_alter;

;

COMMIT;

