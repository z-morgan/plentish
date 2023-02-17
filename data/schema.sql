CREATE TABLE users(
  id serial PRIMARY KEY,
  username varchar(50) NOT NULL UNIQUE,
  password text NOT NULL,
  current_list_id int -- NOT NULL
);

CREATE TABLE shopping_lists(
  id serial PRIMARY KEY,
  date_created date NOT NULL DEFAULT CURRENT_DATE,
  date_archived date,
  user_id int NOT NULL REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE recipes(
  id serial PRIMARY KEY,
  name varchar(200) NOT NULL,
  date_created date NOT NULL DEFAULT CURRENT_DATE,
  description text,
  user_id int NOT NULL REFERENCES users(id) ON DELETE CASCADE
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
  pantry boolean NOT NULL DEFAULT false,
  shopping_list_id int REFERENCES shopping_lists(id) ON DELETE CASCADE
);
