
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