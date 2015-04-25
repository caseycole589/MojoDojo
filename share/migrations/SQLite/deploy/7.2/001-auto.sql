-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Fri Apr 24 15:59:03 2015
-- 

;
BEGIN TRANSACTION;
--
-- Table: companys
--
CREATE TABLE companys (
  id INTEGER PRIMARY KEY NOT NULL,
  name text NOT NULL
);
CREATE UNIQUE INDEX companys_name ON companys (name);
--
-- Table: users
--
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
--
-- Table: posts
--
CREATE TABLE posts (
  id INTEGER PRIMARY KEY NOT NULL,
  author_id text NOT NULL,
  title text NOT NULL,
  content text NOT NULL,
  date_published datetime NOT NULL,
  FOREIGN KEY (author_id) REFERENCES users(id)
);
CREATE INDEX posts_idx_author_id ON posts (author_id);
--
-- Table: bills
--
CREATE TABLE bills (
  id INTEGER PRIMARY KEY NOT NULL,
  customer_name text NOT NULL,
  company_name text NOT NULL,
  date_published datetime NOT NULL DEFAULT (datetime('now')),
  amount decimal(9,2) DEFAULT 0.00,
  is_payed int NOT NULL,
  FOREIGN KEY (customer_name) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (company_name) REFERENCES companys(id)
);
CREATE INDEX bills_idx_customer_name ON bills (customer_name);
CREATE INDEX bills_idx_company_name ON bills (company_name);
--
-- Table: comments
--
CREATE TABLE comments (
  id INTEGER PRIMARY KEY NOT NULL,
  post_id integer NOT NULL,
  user_id integer NOT NULL,
  created_at datetime DEFAULT (datetime('now')),
  content text NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (post_id) REFERENCES posts(id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX comments_idx_user_id ON comments (user_id);
CREATE INDEX comments_idx_post_id ON comments (post_id);
COMMIT;
