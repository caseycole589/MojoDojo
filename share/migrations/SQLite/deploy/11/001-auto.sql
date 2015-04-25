-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Fri Apr 24 16:10:10 2015
-- 

;
BEGIN TRANSACTION;
--
-- Table: bills
--
CREATE TABLE bills (
  id INTEGER PRIMARY KEY NOT NULL,
  customer_name text NOT NULL,
  company_name text NOT NULL,
  date_published datetime NOT NULL DEFAULT (datetime('now')),
  amount decimal(9,2) NOT NULL,
  is_payed int NOT NULL
);
--
-- Table: companys
--
CREATE TABLE companys (
  id INTEGER PRIMARY KEY NOT NULL,
  name text NOT NULL
);
CREATE UNIQUE INDEX companys_name ON companys (name);
--
-- Table: messages
--
CREATE TABLE messages (
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
-- Table: users
--
CREATE TABLE users (
  id INTEGER PRIMARY KEY NOT NULL,
  pw_hash text NOT NULL,
  username text NOT NULL,
  firstname text NOT NULL,
  lastname text NOT NULL,
  city text NOT NULL,
  zipcode text NOT NULL,
  email text NOT NULL,
  company text NOT NULL,
  user_level text NOT NULL,
  FOREIGN KEY (company) REFERENCES companys(name)
);
CREATE INDEX users_idx_company ON users (company);
CREATE UNIQUE INDEX users_username ON users (username);
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
