
INSERT INTO users
(username, password)
VALUES ('asdfasdf', 'Password123');

INSERT INTO shopping_lists
(user_id) VALUES (1);

UPDATE users
SET current_list_id = 1
WHERE id = 1;

INSERT INTO recipes
(name, user_id)
VALUES ('Smith Rock Granola', 1);

INSERT INTO recipes
(name, user_id)
VALUES ('Banana Pancakes', 1);

INSERT INTO ingredients
(name, quantity, units, recipe_id)
VALUES ('Almonds', 10, 'oz.', 1);

INSERT INTO ingredients
(name, quantity, units, recipe_id)
VALUES ('Oats', 2, 'cups', 1);

INSERT INTO ingredients
(name, quantity, units, recipe_id)
VALUES ('Walnuts', 4, 'cups', 1);

INSERT INTO ingredients
(name, quantity, units, recipe_id)
VALUES ('Bananas', 5, 'ct.', 2);

INSERT INTO ingredients
(name, quantity, units, recipe_id)
VALUES ('Oats', 1, 'cups', 2);

INSERT INTO items
(name, quantity, units, done, shopping_list_id)
VALUES ('Dried Cranberries', 1, 'cup', true, 1);

INSERT INTO items
(name, quantity, units, shopping_list_id)
VALUES ('Bananas', 2, 'ct.', 1);

INSERT INTO items
(name, quantity, units, deleted, shopping_list_id)
VALUES ('Emergen-C', 1, 'ct.', true, 1);