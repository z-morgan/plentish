
INSERT INTO users
(username, password)
VALUES ('asdfasdf', '$2a$12$.cbgLGK9OBqJIlhjOYmp2e63lnPFFboWeeFKcndx36xfSgzWhjI/i');

INSERT INTO shopping_lists
(user_id) VALUES (1);

UPDATE users
SET current_list_id = 1
WHERE id = 1;

INSERT INTO recipes
(name, description, user_id)
VALUES ('Smith Rock Granola', 'A yummy treat! - Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Nec nam aliquam sem et tortor consequat id. Posuere sollicitudin aliquam ultrices sagittis orci a. Arcu bibendum at varius vel pharetra vel turpis nunc eget. Turpis egestas sed tempus urna et pharetra pharetra. Enim blandit volutpat maecenas volutpat blandit. Neque sodales ut etiam sit amet nisl purus in. Phasellus vestibulum lorem sed risus ultricies tristique nulla. Amet cursus sit amet dictum sit amet justo donec. Morbi tincidunt augue interdum velit euismod in pellentesque massa.

Arcu odio ut sem nulla pharetra diam sit amet. Sapien nec sagittis aliquam malesuada bibendum arcu vitae elementum curabitur. At elementum eu facilisis sed. Rhoncus urna neque viverra justo nec. Dignissim enim sit amet venenatis urna cursus eget nunc scelerisque. Curabitur vitae nunc sed velit dignissim sodales ut. Egestas quis ipsum suspendisse ultrices gravida dictum fusce ut. Nunc sed blandit libero volutpat. Sed elementum tempus egestas sed sed risus pretium quam vulputate. Urna id volutpat lacus laoreet non curabitur gravida.',
1);

INSERT INTO recipes
(name, user_id)
VALUES ('Banana Pancakes', 1);

INSERT INTO ingredients
(name, quantity, units, recipe_id)
VALUES ('Almonds', 10, 'oz', 1);

INSERT INTO ingredients
(name, quantity, units, recipe_id)
VALUES ('Oats', 2, 'cup', 1);

INSERT INTO ingredients
(name, quantity, units, recipe_id)
VALUES ('Walnuts', 4, 'cup', 1);

INSERT INTO ingredients
(name, quantity, units, recipe_id)
VALUES ('Bananas', 5, 'ct.', 2);

INSERT INTO ingredients
(name, quantity, units, recipe_id)
VALUES ('Oats', 1, 'cup', 2);

INSERT INTO items
(name, quantity, units, done, shopping_list_id)
VALUES ('Dried Cranberries', 1, 'cup', true, 1);

INSERT INTO items
(name, quantity, units, done, shopping_list_id)
VALUES ('Potstickers', 50, 'count', true, 1);

INSERT INTO items
(name, quantity, units, done, shopping_list_id)
VALUES ('Dried Mangos', 1, 'count', true, 1);

INSERT INTO items
(name, quantity, units, done, shopping_list_id)
VALUES ('Peanuts', 5, 'cup', true, 1);

INSERT INTO items
(name, quantity, units, done, shopping_list_id)
VALUES ('Popcorn', 10, 'count', true, 1);

INSERT INTO items
(name, quantity, units, done, shopping_list_id)
VALUES ('Carrots', 10, 'g', true, 1);

INSERT INTO items
(name, quantity, units, done, shopping_list_id)
VALUES ('Pocky Sticks', 1, 'count', true, 1);

INSERT INTO items
(name, quantity, units, done, shopping_list_id)
VALUES ('Raisens', 10, 'cup', true, 1);

INSERT INTO items
(name, quantity, units, done, shopping_list_id)
VALUES ('Orange Juice', 1, 'cup', true, 1);

INSERT INTO items
(name, quantity, units, shopping_list_id)
VALUES ('Bananas', 6, 'count', 1);

INSERT INTO items
(name, quantity, units, shopping_list_id)
VALUES ('Cleaning Solution', 32, 'fl. oz', 1);

INSERT INTO items
(name, quantity, units, shopping_list_id)
VALUES ('Cherries', 25, 'count', 1);

INSERT INTO items
(name, quantity, units, shopping_list_id)
VALUES ('Bacon', 30, 'count', 1);

INSERT INTO items
(name, quantity, units, shopping_list_id)
VALUES ('Cabbage', 2, 'count', 1);

INSERT INTO items
(name, quantity, units, shopping_list_id)
VALUES ('Baby Food', 10, 'cups', 1);

INSERT INTO items
(name, quantity, units, shopping_list_id)
VALUES ('Eggs', 18, 'count', 1);

INSERT INTO items
(name, quantity, units, shopping_list_id)
VALUES ('Milk', 1, 'gal', 1);

INSERT INTO items
(name, quantity, units, shopping_list_id)
VALUES ('Barbeque Sauce', 24, 'fl. oz', 1);

INSERT INTO items
(name, quantity, units, shopping_list_id)
VALUES ('Bandaids', 20, 'count', 1);

INSERT INTO items
(name, quantity, units, shopping_list_id)
VALUES ('Potato Chips', 2, 'count', 1);

INSERT INTO items
(name, quantity, units, deleted, shopping_list_id)
VALUES ('Emergen-C', 1, 'count', true, 1);
