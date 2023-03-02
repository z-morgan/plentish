CREATE TABLE users(
  id serial PRIMARY KEY,
  username varchar(50) NOT NULL UNIQUE,
  password text NOT NULL,
  current_list_id int
);

CREATE TABLE shopping_lists(
  id serial PRIMARY KEY,
  date_created timestamp NOT NULL DEFAULT now(),
  date_archived timestamp,
  user_id int NOT NULL REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE recipes(
  id serial PRIMARY KEY,
  name varchar(200) NOT NULL,
  date_created timestamp NOT NULL DEFAULT now(),
  description text,
  user_id int NOT NULL REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE recipes_shopping_lists(
  id serial PRIMARY KEY,
  recipe_id int REFERENCES recipes(id) ON DELETE CASCADE,
  shopping_list_id int REFERENCES shopping_lists(id) ON DELETE CASCADE
);

CREATE TABLE ingredients(
  id serial PRIMARY KEY,
  name varchar(50) NOT NULL,
  quantity real,
  units varchar(10),
  recipe_id int REFERENCES recipes(id) ON DELETE CASCADE
);

CREATE TABLE items(
  id serial PRIMARY KEY,
  name varchar(50) NOT NULL,
  quantity real,
  units varchar(10),
  done boolean NOT NULL DEFAULT false,
  deleted boolean NOT NULL DEFAULT false,
  shopping_list_id int REFERENCES shopping_lists(id) ON DELETE CASCADE
);

-- Used these statements to add the demo account feature:
ALTER TABLE users ADD COLUMN last_login_time timestamp;

INSERT INTO users
(username, password, last_login_time)
VALUES ('DemoUser1', '$2a$12$.cbgLGK9OBqJIlhjOYmp2e63lnPFFboWeeFKcndx36xfSgzWhjI/i', '2023-03-01 16:57:32.286531');

INSERT INTO users
(username, password, last_login_time)
VALUES ('DemoUser2', '$2a$12$.cbgLGK9OBqJIlhjOYmp2e63lnPFFboWeeFKcndx36xfSgzWhjI/i', '2023-03-01 16:58:07.230395');

INSERT INTO users
(username, password, last_login_time)
VALUES ('DemoUser3', '$2a$12$.cbgLGK9OBqJIlhjOYmp2e63lnPFFboWeeFKcndx36xfSgzWhjI/i', '2023-03-01 16:58:23.385317');
