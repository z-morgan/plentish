-- One time statements for adding demo account feature:
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


-- Following statements delete current data from a demo account, id/user_id is variable:
UPDATE users SET current_list_id = NULL WHERE id = 3;
DELETE FROM recipes WHERE user_id = 3;
DELETE FROM shopping_lists WHERE user_id = 3;


-- Remaining code adds the demo data to DemoUser1

INSERT INTO shopping_lists
(user_id) VALUES (3)  -- this assumes DemoUser1 has an id of 3 (this will be a variable)
RETURNING id;

UPDATE users
SET current_list_id = --whatever id is returned by the previous statement
WHERE id = 3;  -- variable


-- adding the recipes:

-- the user_id will be variable
-- each of these returns the id of the new recipe
INSERT INTO recipes (name, description, user_id) VALUES ('Blueberry Muffins', 'How to make these tasty treats:

1. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Adipiscing elit duis tristique sollicitudin nibh. Massa id neque aliquam vestibulum morbi blandit. Risus pretium quam vulputate dignissim suspendisse in est. Faucibus pulvinar elementum integer enim neque volutpat ac tincidunt. Turpis tincidunt id aliquet risus. Volutpat lacus laoreet non curabitur gravida arcu ac. Nisi lacus sed viverra tellus in. Enim sit amet venenatis urna cursus eget. Enim neque volutpat ac tincidunt vitae semper quis lectus. Risus at ultrices mi tempus imperdiet nulla malesuada pellentesque. Volutpat blandit aliquam etiam erat. Pellentesque sit amet porttitor eget dolor morbi. Integer enim neque volutpat ac tincidunt vitae. Aliquet lectus proin nibh nisl condimentum id venenatis a condimentum. Enim neque volutpat ac tincidunt vitae semper quis. Sapien eget mi proin sed libero enim sed.

2. Sed nisi lacus sed viverra tellus in hac. A cras semper auctor neque vitae tempus quam pellentesque nec. Feugiat in ante metus dictum at tempor commodo. Proin sed libero enim sed faucibus turpis in eu. Sagittis purus sit amet volutpat consequat mauris nunc. Tortor vitae purus faucibus ornare suspendisse sed nisi lacus. Sed vulputate odio ut enim blandit volutpat. Porttitor rhoncus dolor purus non enim. Vitae auctor eu augue ut lectus arcu bibendum at. Sodales ut etiam sit amet nisl purus in. At urna condimentum mattis pellentesque id nibh. Aliquet nibh praesent tristique magna sit. Sed elementum tempus egestas sed sed risus pretium.

3. Pellentesque pulvinar pellentesque habitant morbi tristique senectus et netus. Eleifend mi in nulla posuere sollicitudin aliquam ultrices sagittis orci. Congue nisi vitae suscipit tellus mauris. Nunc sed id semper risus in hendrerit. Feugiat nisl pretium fusce id velit ut. Lectus vestibulum mattis ullamcorper velit sed ullamcorper morbi. Ut sem nulla pharetra diam sit amet nisl suscipit. Eu sem integer vitae justo eget magna fermentum iaculis. Quisque sagittis purus sit amet volutpat consequat mauris. Pulvinar sapien et ligula ullamcorper malesuada. Purus non enim praesent elementum facilisis leo vel fringilla est.

4. Id aliquet lectus proin nibh nisl condimentum id venenatis. Ut faucibus pulvinar elementum integer enim neque volutpat ac tincidunt. Sed risus ultricies tristique nulla aliquet. At tempor commodo ullamcorper a lacus vestibulum sed arcu. Eget lorem dolor sed viverra ipsum nunc aliquet bibendum. Eu augue ut lectus arcu bibendum at varius vel. Sit amet porttitor eget dolor morbi non. Turpis nunc eget lorem dolor sed viverra ipsum. Mi proin sed libero enim sed. Sem viverra aliquet eget sit amet tellus cras.

5. Sem nulla pharetra diam sit amet nisl suscipit adipiscing bibendum. Ultricies leo integer malesuada nunc vel risus commodo viverra maecenas. Adipiscing vitae proin sagittis nisl rhoncus mattis. Vitae auctor eu augue ut lectus arcu bibendum at varius. Vitae turpis massa sed elementum tempus egestas sed sed risus. Pellentesque habitant morbi tristique senectus et netus. Vitae aliquet nec ullamcorper sit amet risus nullam eget. In metus vulputate eu scelerisque felis. In nulla posuere sollicitudin aliquam ultrices. Consectetur adipiscing elit pellentesque habitant morbi tristique senectus et netus. Sit amet consectetur adipiscing elit ut aliquam purus. Leo duis ut diam quam nulla porttitor massa id. Sit amet luctus venenatis lectus. Mi eget mauris pharetra et ultrices neque ornare. Non consectetur a erat nam at lectus urna duis.', 3) RETURNING id;

INSERT INTO recipes (name, description, user_id) VALUES ('Tasty Pasta', 'After collecting the ingredients, do the following:

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Mi sit amet mauris commodo quis imperdiet. Consequat mauris nunc congue nisi. Porttitor lacus luctus accumsan tortor posuere ac ut consequat semper. Enim eu turpis egestas pretium aenean pharetra magna ac placerat. Elit sed vulputate mi sit amet. Blandit volutpat maecenas volutpat blandit. Eget magna fermentum iaculis eu. Vulputate enim nulla aliquet porttitor lacus luctus accumsan tortor posuere. Elit duis tristique sollicitudin nibh sit amet commodo nulla facilisi. Id nibh tortor id aliquet lectus proin. Et tortor consequat id porta.

Sit amet porttitor eget dolor. Fames ac turpis egestas sed tempus urna et pharetra. Nisi vitae suscipit tellus mauris a diam maecenas. Sit amet luctus venenatis lectus magna fringilla urna porttitor rhoncus. A iaculis at erat pellentesque adipiscing commodo. Diam ut venenatis tellus in. Porta non pulvinar neque laoreet suspendisse. Ultrices neque ornare aenean euismod elementum nisi. Ac auctor augue mauris augue neque gravida in fermentum et. Quis hendrerit dolor magna eget est lorem ipsum. Risus quis varius quam quisque id diam. Porta non pulvinar neque laoreet suspendisse interdum. Malesuada fames ac turpis egestas integer eget aliquet nibh. Nullam non nisi est sit amet. Lectus mauris ultrices eros in cursus turpis massa tincidunt dui. Tellus in metus vulputate eu scelerisque. Quisque id diam vel quam elementum pulvinar etiam. Amet purus gravida quis blandit turpis cursus.', 3) RETURNING id;

INSERT INTO recipes (name, description, user_id) VALUES ('Fancy Pizza', 'Perfecto! Arcu odio ut sem nulla pharetra diam sit amet. Sapien nec sagittis aliquam malesuada bibendum arcu vitae elementum curabitur. At elementum eu facilisis sed. Rhoncus urna neque viverra justo nec. Dignissim enim sit amet venenatis urna cursus eget nunc scelerisque. Curabitur vitae nunc sed velit dignissim sodales ut. Egestas quis ipsum suspendisse ultrices gravida dictum fusce ut. Nunc sed blandit libero volutpat. Sed elementum tempus egestas sed sed risus pretium quam vulputate. Urna id volutpat lacus laoreet non curabitur gravida.', 3) RETURNING id;

INSERT INTO recipes (name, description, user_id) VALUES ('Banana Pancakes', 'A yummy treat!

Step 1. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. 

Step 2. Nec nam aliquam sem et tortor consequat id. Posuere sollicitudin aliquam ultrices sagittis orci a. Arcu bibendum at varius vel pharetra vel turpis nunc eget. Turpis egestas sed tempus urna et pharetra pharetra. 

Step 3. Enim blandit volutpat maecenas volutpat blandit. Neque sodales ut etiam sit amet nisl purus in. Phasellus vestibulum lorem sed risus ultricies tristique nulla. Amet cursus sit amet dictum sit amet justo donec. Morbi tincidunt augue interdum velit euismod in pellentesque massa.', 3) RETURNING id;


-- adding ingredients:

-- where the recipe_id is the id of a recipe from above
INSERT INTO (name, quantity, units, recipe_id) VALUES ('Bananas', 4, 'count', 1);
INSERT INTO (name, quantity, units, recipe_id) VALUES ('Flour', 6, 'cup', 1);
INSERT INTO (name, quantity, units, recipe_id) VALUES ('Water', 10, 'fl. oz', 1);
INSERT INTO (name, quantity, units, recipe_id) VALUES ('Cinnamon', 5, 'tsp', 1);
INSERT INTO (name, quantity, units, recipe_id) VALUES ('Salt', 2, 'tsp', 1);
INSERT INTO (name, quantity, units, recipe_id) VALUES ('Butter', 0.25, 'stick', 1);
INSERT INTO (name, quantity, units, recipe_id) VALUES ('Pepperoni', 5, 'bag', 2);
INSERT INTO (name, quantity, units, recipe_id) VALUES ('Cheese', 20, 'cup', 2);
INSERT INTO (name, quantity, units, recipe_id) VALUES ('Salami', 2.5, 'cup', 2);
INSERT INTO (name, quantity, units, recipe_id) VALUES ('Olives', 1, 'can', 2);
INSERT INTO (name, quantity, units, recipe_id) VALUES ('Chipotle Honey', 2, 'fl. oz', 2);
INSERT INTO (name, quantity, units, recipe_id) VALUES ('Potatoes', 0.25, 'kg', 2);
INSERT INTO (name, quantity, units, recipe_id) VALUES ('Tomato Sauce', 1, 'bottle', 2);
INSERT INTO (name, quantity, units, recipe_id) VALUES ('Blueberries', 5, 'cup', 3);
INSERT INTO (name, quantity, units, recipe_id) VALUES ('Flour', 6, 'cup', 3);
INSERT INTO (name, quantity, units, recipe_id) VALUES ('Flax Seeds', 30, 'g', 3);
INSERT INTO (name, quantity, units, recipe_id) VALUES ('Sugar', 2, 'cup', 3);
INSERT INTO (name, quantity, units, recipe_id) VALUES ('Lemon Zest', 2, 'tbsp', 3);
INSERT INTO (name, quantity, units, recipe_id) VALUES ('Noodles', 1, 'box', 4);
INSERT INTO (name, quantity, units, recipe_id) VALUES ('Salt', 4, 'tsp', 4);
INSERT INTO (name, quantity, units, recipe_id) VALUES ('Water', 2, 'pt', 4);
INSERT INTO (name, quantity, units, recipe_id) VALUES ('Cream Sauce', 0.5, 'L', 4);
INSERT INTO (name, quantity, units, recipe_id) VALUES ('Basil', 1.5, 'tbsp', 4);
INSERT INTO (name, quantity, units, recipe_id) VALUES ('Garlic', 0.75, 'cup', 4);


-- selecting a recipe:

-- both values are variable, and depend on above statements
INSERT INTO recipes_shopping_lists
(recipe_id, shopping_list_id)
VALUES (3, 1);


-- adding remaining shopping lists:

-- user_id is variable, each returns an id for use in setting items, current_list was set above, and is omitted here
INSERT INTO shopping_lists (date_created, user_id) VALUES ('2023-02-28 16:26:33.407959', 3) RETURNING id;
INSERT INTO shopping_lists (date_created, user_id) VALUES ('2023-02-28 17:02:47.769088', 3) RETURNING id;
INSERT INTO shopping_lists (date_created, user_id) VALUES ('2023-02-28 17:07:27.99036', 3) RETURNING id;
INSERT INTO shopping_lists (date_created, user_id) VALUES ('2023-03-01 08:59:45.869137', 3) RETURNING id;
INSERT INTO shopping_lists (date_created, user_id) VALUES ('2023-03-01 09:00:17.527464', 3) RETURNING id;
INSERT INTO shopping_lists (date_created, user_id) VALUES ('2023-03-01 10:05:02.242242', 3) RETURNING id;
INSERT INTO shopping_lists (date_created, user_id) VALUES ('2023-03-01 10:12:09.17031', 3) RETURNING id;
INSERT INTO shopping_lists (date_created, user_id) VALUES ('2023-03-01 13:54:26.055463', 3) RETURNING id;
INSERT INTO shopping_lists (date_created, user_id) VALUES ('2023-03-01 14:01:24.980971', 3) RETURNING id;
INSERT INTO shopping_lists (date_created, user_id) VALUES ('2023-03-01 14:05:09.472416', 3) RETURNING id;
INSERT INTO shopping_lists (date_created, user_id) VALUES ('2023-03-01 14:06:00.745936', 3) RETURNING id;
INSERT INTO shopping_lists (date_created, user_id) VALUES ('2023-03-01 14:09:45.91567', 3) RETURNING id;


-- adding items:

-- the shopping_list_id is variable, and depends on above statements, the last few statements must match the current_list_id
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Garlic', 0.75, 'cup', 9);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Barbeque Sauce', 2, 'bottle', 5);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Bananas', 12, 'count', 9);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Flour', 18, 'cup', 9);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ( 'Water', 30, 'fl. oz', 9);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Chipotle Honey', 5, 'fl. oz', 7);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ( 'Cinnamon', 15, 'tsp', 9);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Pepperoni', 20, 'bag', 7);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Salt', 4, 'tsp', 9);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ( 'Butter', 0.25, 'stick', 9);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ( 'Blueberries', 5, 'cup', 10);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Salami', 10.5, 'cup', 7);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Salsa', 4.06, 'cup', 7);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ( 'Flax Seeds', 30, 'g', 10);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ( 'Flour', 6, 'cup', 10);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Cheese', 20, 'cup', 1);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ( 'Sugar', 2, 'cup', 10);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Bananas', 4, 'count', 7);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Tomato Sauce', 1, 'bottle', 1);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Lettuce', 2, 'bag', 2);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Flour', 6, 'cup', 7);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Mustard', 1, 'bottle', 2);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('French Fries', 15, 'oz', 2);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Beef Patties', 10, 'count', 2);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Burger Buns', 1, 'bag', 2);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Ketchup', 2, 'bottle', 2);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Barbeque Sauce', 1, 'bottle', 2);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Potato Salad', 2, 'box', 2);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Water', 10, 'fl. oz', 7);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Pepperoni', 5, 'bag', 2);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Cheese', 20, 'cup', 2);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Chipotle Honey', 2, 'fl. oz', 2);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Tomato Sauce', 1, 'bottle', 2);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ( 'Lemon Zest', 2, 'tbsp', 10);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Butter', 0.75, 'stick', 7);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ( 'Apple Joice', 2, 'bottle', 10);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ( 'Blueberries', 5, 'cup', 11);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ( 'Flour', 6, 'cup', 11);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ( 'Flax Seeds', 30, 'g', 11);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Bananas', 4, 'count', 3);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Flour', 6, 'cup', 3);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Water', 10, 'fl. oz', 3);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Cinnamon', 5, 'tsp', 3);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Salt', 2, 'tsp', 3);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ( 'Sugar', 2, 'cup', 11);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ( 'Lemon Zest', 2, 'tbsp', 11);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ( 'Apple Sauce', 2, 'cup', 11);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ( 'Dr. Pepper', 2, 'can', 11);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ( 'Emergen-c', 50, 'count', 11);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ( 'Hotdogs', 2, 'bag', 11);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Olives', 2, 'can', 7);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ( 'Ice Cream', 1, 'lb', 11);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ( 'Quesadilla', 2, 'count', 11);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ( 'Roast Beef', 2, 'lb', 11);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ( 'Udon Noodles', 2, 'box', 12);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ( 'Xiao Long Bao', 2, 'kg', 12);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ( 'Yogurt', 2, 'cup', 12);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Cheese', 45, 'cup', 4);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ( 'Zucchini', 10, 'count', 12);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Tomato Sauce', 2, 'bottle', 4);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Chips', 0.41, 'count', 7);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Salt', 2, 'tsp', 7);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Cinnamon', 5, 'tsp', 7);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Flax Seeds', 30, 'g', 8);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Sugar', 2, 'cup', 8);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Lemon Zest', 2, 'tbsp', 8);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Frozen Flan', 4, 'gal', 8);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Cheese', 21, 'cup', 7);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Tomato Sauce', 2, 'bottle', 7);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Jolly Ranchers', 2, 'dozen', 8);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Flour', 6, 'cup', 8);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Blueberries', 5, 'cup', 8);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Noodles', 1, 'box', 9);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Water', 2, 'pt', 9);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Cream Sauce', 0.5, 'L', 9);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Basil', 1.5, 'tbsp', 9);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Chipotle Honey', 2, 'fl. oz', 1);
INSERT INTO items (name, quantity, units, shopping_list_id) VALUES ('Vanilla Extract', 2, 'bottle', 12);
INSERT INTO items (name, quantity, units, deleted, done, shopping_list_id) VALUES ( 'Rice', 2.5, 'kg', true, true, 0);
INSERT INTO items (name, quantity, units, deleted, done, shopping_list_id) VALUES ( 'Lemon Zest', 2, 'tbsp', false, false, 0);
INSERT INTO items (name, quantity, units, deleted, done, shopping_list_id) VALUES ( 'Poppy Seeds', 2, 'cup', false, true, 0);
INSERT INTO items (name, quantity, units, deleted, done, shopping_list_id) VALUES ( 'Tea', 0.5, 'g', false, false, 0);
INSERT INTO items (name, quantity, units, deleted, done, shopping_list_id) VALUES ( 'Sugar', 2, 'cup', false, true, 0);
INSERT INTO items (name, quantity, units, deleted, done, shopping_list_id) VALUES ( 'Flour', 6, 'cup', false, true, 0);
INSERT INTO items (name, quantity, units, deleted, done, shopping_list_id) VALUES ( 'Flax Seeds', 30, 'g', false, false, 0);
INSERT INTO items (name, quantity, units, deleted, done, shopping_list_id) VALUES ( 'Blueberries', 5, 'cup', false, false, 0);
INSERT INTO items (name, quantity, units, deleted, done, shopping_list_id) VALUES ( 'Tabasco Sauce', 1, 'bottle', true, true, 0);