--
-- PostgreSQL database dump
--

-- Dumped from database version 15.2 (Homebrew)
-- Dumped by pg_dump version 15.2 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ingredients; Type: TABLE; Schema: public; Owner: zmorgan
--

CREATE TABLE public.ingredients (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    quantity real,
    units character varying(10),
    recipe_id integer
);


ALTER TABLE public.ingredients OWNER TO zmorgan;

--
-- Name: ingredients_id_seq; Type: SEQUENCE; Schema: public; Owner: zmorgan
--

CREATE SEQUENCE public.ingredients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ingredients_id_seq OWNER TO zmorgan;

--
-- Name: ingredients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: zmorgan
--

ALTER SEQUENCE public.ingredients_id_seq OWNED BY public.ingredients.id;


--
-- Name: items; Type: TABLE; Schema: public; Owner: zmorgan
--

CREATE TABLE public.items (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    quantity real,
    units character varying(10),
    done boolean DEFAULT false NOT NULL,
    deleted boolean DEFAULT false NOT NULL,
    shopping_list_id integer
);


ALTER TABLE public.items OWNER TO zmorgan;

--
-- Name: items_id_seq; Type: SEQUENCE; Schema: public; Owner: zmorgan
--

CREATE SEQUENCE public.items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.items_id_seq OWNER TO zmorgan;

--
-- Name: items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: zmorgan
--

ALTER SEQUENCE public.items_id_seq OWNED BY public.items.id;


--
-- Name: recipes; Type: TABLE; Schema: public; Owner: zmorgan
--

CREATE TABLE public.recipes (
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    date_created timestamp without time zone DEFAULT now() NOT NULL,
    description text,
    user_id integer NOT NULL
);


ALTER TABLE public.recipes OWNER TO zmorgan;

--
-- Name: recipes_id_seq; Type: SEQUENCE; Schema: public; Owner: zmorgan
--

CREATE SEQUENCE public.recipes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.recipes_id_seq OWNER TO zmorgan;

--
-- Name: recipes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: zmorgan
--

ALTER SEQUENCE public.recipes_id_seq OWNED BY public.recipes.id;


--
-- Name: recipes_shopping_lists; Type: TABLE; Schema: public; Owner: zmorgan
--

CREATE TABLE public.recipes_shopping_lists (
    id integer NOT NULL,
    recipe_id integer,
    shopping_list_id integer
);


ALTER TABLE public.recipes_shopping_lists OWNER TO zmorgan;

--
-- Name: recipes_shopping_lists_id_seq; Type: SEQUENCE; Schema: public; Owner: zmorgan
--

CREATE SEQUENCE public.recipes_shopping_lists_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.recipes_shopping_lists_id_seq OWNER TO zmorgan;

--
-- Name: recipes_shopping_lists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: zmorgan
--

ALTER SEQUENCE public.recipes_shopping_lists_id_seq OWNED BY public.recipes_shopping_lists.id;


--
-- Name: shopping_lists; Type: TABLE; Schema: public; Owner: zmorgan
--

CREATE TABLE public.shopping_lists (
    id integer NOT NULL,
    date_created timestamp without time zone DEFAULT now() NOT NULL,
    date_archived timestamp without time zone,
    user_id integer NOT NULL
);


ALTER TABLE public.shopping_lists OWNER TO zmorgan;

--
-- Name: shopping_lists_id_seq; Type: SEQUENCE; Schema: public; Owner: zmorgan
--

CREATE SEQUENCE public.shopping_lists_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.shopping_lists_id_seq OWNER TO zmorgan;

--
-- Name: shopping_lists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: zmorgan
--

ALTER SEQUENCE public.shopping_lists_id_seq OWNED BY public.shopping_lists.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: zmorgan
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    password text NOT NULL,
    current_list_id integer
);


ALTER TABLE public.users OWNER TO zmorgan;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: zmorgan
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO zmorgan;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: zmorgan
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: ingredients id; Type: DEFAULT; Schema: public; Owner: zmorgan
--

ALTER TABLE ONLY public.ingredients ALTER COLUMN id SET DEFAULT nextval('public.ingredients_id_seq'::regclass);


--
-- Name: items id; Type: DEFAULT; Schema: public; Owner: zmorgan
--

ALTER TABLE ONLY public.items ALTER COLUMN id SET DEFAULT nextval('public.items_id_seq'::regclass);


--
-- Name: recipes id; Type: DEFAULT; Schema: public; Owner: zmorgan
--

ALTER TABLE ONLY public.recipes ALTER COLUMN id SET DEFAULT nextval('public.recipes_id_seq'::regclass);


--
-- Name: recipes_shopping_lists id; Type: DEFAULT; Schema: public; Owner: zmorgan
--

ALTER TABLE ONLY public.recipes_shopping_lists ALTER COLUMN id SET DEFAULT nextval('public.recipes_shopping_lists_id_seq'::regclass);


--
-- Name: shopping_lists id; Type: DEFAULT; Schema: public; Owner: zmorgan
--

ALTER TABLE ONLY public.shopping_lists ALTER COLUMN id SET DEFAULT nextval('public.shopping_lists_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: zmorgan
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: ingredients; Type: TABLE DATA; Schema: public; Owner: zmorgan
--

INSERT INTO public.ingredients VALUES (110, 'Bananas', 4, 'count', 1);
INSERT INTO public.ingredients VALUES (111, 'Flour', 6, 'cup', 1);
INSERT INTO public.ingredients VALUES (112, 'Water', 10, 'fl. oz', 1);
INSERT INTO public.ingredients VALUES (113, 'Cinnamon', 5, 'tsp', 1);
INSERT INTO public.ingredients VALUES (114, 'Salt', 2, 'tsp', 1);
INSERT INTO public.ingredients VALUES (115, 'Butter', 0.25, 'stick', 1);
INSERT INTO public.ingredients VALUES (49, 'Pepperoni', 5, 'bag', 2);
INSERT INTO public.ingredients VALUES (50, 'Cheese', 20, 'cup', 2);
INSERT INTO public.ingredients VALUES (51, 'Salami', 2.5, 'cup', 2);
INSERT INTO public.ingredients VALUES (52, 'Olives', 1, 'can', 2);
INSERT INTO public.ingredients VALUES (53, 'Chipotle Honey', 2, 'fl. oz', 2);
INSERT INTO public.ingredients VALUES (54, 'Potatoes', 0.25, 'kg', 2);
INSERT INTO public.ingredients VALUES (55, 'Tomato Sauce', 1, 'bottle', 2);
INSERT INTO public.ingredients VALUES (116, 'Blueberries', 5, 'cup', 3);
INSERT INTO public.ingredients VALUES (117, 'Flour', 6, 'cup', 3);
INSERT INTO public.ingredients VALUES (118, 'Flax Seeds', 30, 'g', 3);
INSERT INTO public.ingredients VALUES (119, 'Sugar', 2, 'cup', 3);
INSERT INTO public.ingredients VALUES (120, 'Lemon Zest', 2, 'tbsp', 3);
INSERT INTO public.ingredients VALUES (121, 'Noodles', 1, 'box', 4);
INSERT INTO public.ingredients VALUES (122, 'Salt', 4, 'tsp', 4);
INSERT INTO public.ingredients VALUES (123, 'Water', 2, 'pt', 4);
INSERT INTO public.ingredients VALUES (124, 'Cream Sauce', 0.5, 'L', 4);
INSERT INTO public.ingredients VALUES (125, 'Basil', 1.5, 'tbsp', 4);
INSERT INTO public.ingredients VALUES (126, 'Garlic', 0.75, 'cup', 4);


--
-- Data for Name: items; Type: TABLE DATA; Schema: public; Owner: zmorgan
--

INSERT INTO public.items VALUES (97, 'Garlic', 0.75, 'cup', false, true, 9);
INSERT INTO public.items VALUES (56, 'Barbeque Sauce', 2, 'bottle', false, false, 5);
INSERT INTO public.items VALUES (98, 'Bananas', 12, 'count', false, true, 9);
INSERT INTO public.items VALUES (99, 'Flour', 18, 'cup', false, true, 9);
INSERT INTO public.items VALUES (100, 'Water', 30, 'fl. oz', false, true, 9);
INSERT INTO public.items VALUES (68, 'Chipotle Honey', 5, 'fl. oz', false, true, 7);
INSERT INTO public.items VALUES (101, 'Cinnamon', 15, 'tsp', false, true, 9);
INSERT INTO public.items VALUES (64, 'Pepperoni', 20, 'bag', false, false, 7);
INSERT INTO public.items VALUES (93, 'Salt', 4, 'tsp', false, true, 9);
INSERT INTO public.items VALUES (102, 'Butter', 0.25, 'stick', false, true, 9);
INSERT INTO public.items VALUES (103, 'Blueberries', 5, 'cup', false, false, 10);
INSERT INTO public.items VALUES (66, 'Salami', 10.5, 'cup', false, false, 7);
INSERT INTO public.items VALUES (79, 'Salsa', 4.06, 'cup', false, true, 7);
INSERT INTO public.items VALUES (105, 'Flax Seeds', 30, 'g', false, false, 10);
INSERT INTO public.items VALUES (104, 'Flour', 6, 'cup', true, false, 10);
INSERT INTO public.items VALUES (8, 'Cheese', 20, 'cup', false, false, 1);
INSERT INTO public.items VALUES (106, 'Sugar', 2, 'cup', true, false, 10);
INSERT INTO public.items VALUES (11, 'Chipotle Honey', 2, 'fl. oz', false, false, 1);
INSERT INTO public.items VALUES (80, 'Bananas', 4, 'count', false, false, 7);
INSERT INTO public.items VALUES (13, 'Tomato Sauce', 1, 'bottle', false, false, 1);
INSERT INTO public.items VALUES (15, 'Lettuce', 2, 'bag', false, false, 2);
INSERT INTO public.items VALUES (81, 'Flour', 6, 'cup', false, false, 7);
INSERT INTO public.items VALUES (20, 'Mustard', 1, 'bottle', false, false, 2);
INSERT INTO public.items VALUES (21, 'French Fries', 15, 'oz', false, false, 2);
INSERT INTO public.items VALUES (14, 'Beef Patties', 10, 'count', true, false, 2);
INSERT INTO public.items VALUES (17, 'Burger Buns', 1, 'bag', true, false, 2);
INSERT INTO public.items VALUES (19, 'Ketchup', 2, 'bottle', true, false, 2);
INSERT INTO public.items VALUES (16, 'Barbeque Sauce', 1, 'bottle', true, false, 2);
INSERT INTO public.items VALUES (22, 'Potato Salad', 2, 'box', false, true, 2);
INSERT INTO public.items VALUES (82, 'Water', 10, 'fl. oz', false, false, 7);
INSERT INTO public.items VALUES (23, 'Pepperoni', 5, 'bag', false, false, 2);
INSERT INTO public.items VALUES (24, 'Cheese', 20, 'cup', false, false, 2);
INSERT INTO public.items VALUES (27, 'Chipotle Honey', 2, 'fl. oz', false, false, 2);
INSERT INTO public.items VALUES (29, 'Tomato Sauce', 1, 'bottle', false, false, 2);
INSERT INTO public.items VALUES (107, 'Lemon Zest', 2, 'tbsp', true, false, 10);
INSERT INTO public.items VALUES (71, 'Butter', 0.75, 'stick', false, false, 7);
INSERT INTO public.items VALUES (108, 'Apple Joice', 2, 'bottle', false, true, 10);
INSERT INTO public.items VALUES (109, 'Blueberries', 5, 'cup', false, false, 11);
INSERT INTO public.items VALUES (110, 'Flour', 6, 'cup', false, false, 11);
INSERT INTO public.items VALUES (111, 'Flax Seeds', 30, 'g', false, false, 11);
INSERT INTO public.items VALUES (37, 'Bananas', 4, 'count', false, false, 3);
INSERT INTO public.items VALUES (38, 'Flour', 6, 'cup', false, false, 3);
INSERT INTO public.items VALUES (39, 'Water', 10, 'fl. oz', false, false, 3);
INSERT INTO public.items VALUES (40, 'Cinnamon', 5, 'tsp', false, false, 3);
INSERT INTO public.items VALUES (41, 'Salt', 2, 'tsp', false, false, 3);
INSERT INTO public.items VALUES (112, 'Sugar', 2, 'cup', false, false, 11);
INSERT INTO public.items VALUES (113, 'Lemon Zest', 2, 'tbsp', false, false, 11);
INSERT INTO public.items VALUES (114, 'Apple Sauce', 2, 'cup', false, false, 11);
INSERT INTO public.items VALUES (115, 'Dr. Pepper', 2, 'can', false, false, 11);
INSERT INTO public.items VALUES (116, 'Emergen-c', 50, 'count', false, false, 11);
INSERT INTO public.items VALUES (117, 'Hotdogs', 2, 'bag', false, false, 11);
INSERT INTO public.items VALUES (67, 'Olives', 2, 'can', false, false, 7);
INSERT INTO public.items VALUES (118, 'Ice Cream', 1, 'lb', false, false, 11);
INSERT INTO public.items VALUES (119, 'Quesadilla', 2, 'count', false, false, 11);
INSERT INTO public.items VALUES (120, 'Roast Beef', 2, 'lb', false, false, 11);
INSERT INTO public.items VALUES (121, 'Udon Noodles', 2, 'box', false, false, 12);
INSERT INTO public.items VALUES (122, 'Vanilla Extract', 2, 'bottle', false, false, 12);
INSERT INTO public.items VALUES (123, 'Xiao Long Bao', 2, 'kg', false, false, 12);
INSERT INTO public.items VALUES (124, 'Yogurt', 2, 'cup', false, false, 12);
INSERT INTO public.items VALUES (50, 'Cheese', 45, 'cup', false, true, 4);
INSERT INTO public.items VALUES (125, 'Zucchini', 10, 'count', false, false, 12);
INSERT INTO public.items VALUES (127, 'Flour', 6, 'cup', false, false, 13);
INSERT INTO public.items VALUES (55, 'Tomato Sauce', 2, 'bottle', false, true, 4);
INSERT INTO public.items VALUES (130, 'Lemon Zest', 2, 'tbsp', false, false, 13);
INSERT INTO public.items VALUES (131, 'Poppy Seeds', 2, 'cup', false, false, 13);
INSERT INTO public.items VALUES (132, 'Tea', 0.5, 'g', false, false, 13);
INSERT INTO public.items VALUES (129, 'Sugar', 2, 'cup', true, false, 13);
INSERT INTO public.items VALUES (74, 'Chips', 0.41999984, 'count', false, false, 7);
INSERT INTO public.items VALUES (84, 'Salt', 2, 'tsp', true, false, 7);
INSERT INTO public.items VALUES (83, 'Cinnamon', 5, 'tsp', true, false, 7);
INSERT INTO public.items VALUES (87, 'Flax Seeds', 30, 'g', false, false, 8);
INSERT INTO public.items VALUES (88, 'Sugar', 2, 'cup', false, false, 8);
INSERT INTO public.items VALUES (89, 'Lemon Zest', 2, 'tbsp', false, false, 8);
INSERT INTO public.items VALUES (128, 'Flax Seeds', 30, 'g', true, false, 13);
INSERT INTO public.items VALUES (90, 'Frozen Flan', 4, 'gal', false, false, 8);
INSERT INTO public.items VALUES (65, 'Cheese', 21, 'cup', false, false, 7);
INSERT INTO public.items VALUES (70, 'Tomato Sauce', 2, 'bottle', false, false, 7);
INSERT INTO public.items VALUES (91, 'Jolly Ranchers', 2, 'dozen', false, false, 8);
INSERT INTO public.items VALUES (86, 'Flour', 6, 'cup', true, false, 8);
INSERT INTO public.items VALUES (85, 'Blueberries', 5, 'cup', true, false, 8);
INSERT INTO public.items VALUES (126, 'Blueberries', 5, 'cup', true, false, 13);
INSERT INTO public.items VALUES (92, 'Noodles', 1, 'box', false, true, 9);
INSERT INTO public.items VALUES (94, 'Water', 2, 'pt', false, true, 9);
INSERT INTO public.items VALUES (95, 'Cream Sauce', 0.5, 'L', false, true, 9);
INSERT INTO public.items VALUES (96, 'Basil', 1.5, 'tbsp', false, true, 9);
INSERT INTO public.items VALUES (133, 'Tabasco Sauce', 1, 'bottle', false, true, 13);
INSERT INTO public.items VALUES (134, 'Rice', 2.5, 'kg', false, true, 13);


--
-- Data for Name: recipes; Type: TABLE DATA; Schema: public; Owner: zmorgan
--

INSERT INTO public.recipes VALUES (3, 'Blueberry Muffins', '2023-03-01 13:59:48.259875', 'How to make these tasty treats:

1. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Adipiscing elit duis tristique sollicitudin nibh. Massa id neque aliquam vestibulum morbi blandit. Risus pretium quam vulputate dignissim suspendisse in est. Faucibus pulvinar elementum integer enim neque volutpat ac tincidunt. Turpis tincidunt id aliquet risus. Volutpat lacus laoreet non curabitur gravida arcu ac. Nisi lacus sed viverra tellus in. Enim sit amet venenatis urna cursus eget. Enim neque volutpat ac tincidunt vitae semper quis lectus. Risus at ultrices mi tempus imperdiet nulla malesuada pellentesque. Volutpat blandit aliquam etiam erat. Pellentesque sit amet porttitor eget dolor morbi. Integer enim neque volutpat ac tincidunt vitae. Aliquet lectus proin nibh nisl condimentum id venenatis a condimentum. Enim neque volutpat ac tincidunt vitae semper quis. Sapien eget mi proin sed libero enim sed.

2. Sed nisi lacus sed viverra tellus in hac. A cras semper auctor neque vitae tempus quam pellentesque nec. Feugiat in ante metus dictum at tempor commodo. Proin sed libero enim sed faucibus turpis in eu. Sagittis purus sit amet volutpat consequat mauris nunc. Tortor vitae purus faucibus ornare suspendisse sed nisi lacus. Sed vulputate odio ut enim blandit volutpat. Porttitor rhoncus dolor purus non enim. Vitae auctor eu augue ut lectus arcu bibendum at. Sodales ut etiam sit amet nisl purus in. At urna condimentum mattis pellentesque id nibh. Aliquet nibh praesent tristique magna sit. Sed elementum tempus egestas sed sed risus pretium.

3. Pellentesque pulvinar pellentesque habitant morbi tristique senectus et netus. Eleifend mi in nulla posuere sollicitudin aliquam ultrices sagittis orci. Congue nisi vitae suscipit tellus mauris. Nunc sed id semper risus in hendrerit. Feugiat nisl pretium fusce id velit ut. Lectus vestibulum mattis ullamcorper velit sed ullamcorper morbi. Ut sem nulla pharetra diam sit amet nisl suscipit. Eu sem integer vitae justo eget magna fermentum iaculis. Quisque sagittis purus sit amet volutpat consequat mauris. Pulvinar sapien et ligula ullamcorper malesuada. Purus non enim praesent elementum facilisis leo vel fringilla est.

4. Id aliquet lectus proin nibh nisl condimentum id venenatis. Ut faucibus pulvinar elementum integer enim neque volutpat ac tincidunt. Sed risus ultricies tristique nulla aliquet. At tempor commodo ullamcorper a lacus vestibulum sed arcu. Eget lorem dolor sed viverra ipsum nunc aliquet bibendum. Eu augue ut lectus arcu bibendum at varius vel. Sit amet porttitor eget dolor morbi non. Turpis nunc eget lorem dolor sed viverra ipsum. Mi proin sed libero enim sed. Sem viverra aliquet eget sit amet tellus cras.

5. Sem nulla pharetra diam sit amet nisl suscipit adipiscing bibendum. Ultricies leo integer malesuada nunc vel risus commodo viverra maecenas. Adipiscing vitae proin sagittis nisl rhoncus mattis. Vitae auctor eu augue ut lectus arcu bibendum at varius. Vitae turpis massa sed elementum tempus egestas sed sed risus. Pellentesque habitant morbi tristique senectus et netus. Vitae aliquet nec ullamcorper sit amet risus nullam eget. In metus vulputate eu scelerisque felis. In nulla posuere sollicitudin aliquam ultrices. Consectetur adipiscing elit pellentesque habitant morbi tristique senectus et netus. Sit amet consectetur adipiscing elit ut aliquam purus. Leo duis ut diam quam nulla porttitor massa id. Sit amet luctus venenatis lectus. Mi eget mauris pharetra et ultrices neque ornare. Non consectetur a erat nam at lectus urna duis.', 1);
INSERT INTO public.recipes VALUES (4, 'Tasty Pasta', '2023-03-01 14:04:19.689253', 'After collecting the ingredients, do the following:

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Mi sit amet mauris commodo quis imperdiet. Consequat mauris nunc congue nisi. Porttitor lacus luctus accumsan tortor posuere ac ut consequat semper. Enim eu turpis egestas pretium aenean pharetra magna ac placerat. Elit sed vulputate mi sit amet. Blandit volutpat maecenas volutpat blandit. Eget magna fermentum iaculis eu. Vulputate enim nulla aliquet porttitor lacus luctus accumsan tortor posuere. Elit duis tristique sollicitudin nibh sit amet commodo nulla facilisi. Id nibh tortor id aliquet lectus proin. Et tortor consequat id porta.

Sit amet porttitor eget dolor. Fames ac turpis egestas sed tempus urna et pharetra. Nisi vitae suscipit tellus mauris a diam maecenas. Sit amet luctus venenatis lectus magna fringilla urna porttitor rhoncus. A iaculis at erat pellentesque adipiscing commodo. Diam ut venenatis tellus in. Porta non pulvinar neque laoreet suspendisse. Ultrices neque ornare aenean euismod elementum nisi. Ac auctor augue mauris augue neque gravida in fermentum et. Quis hendrerit dolor magna eget est lorem ipsum. Risus quis varius quam quisque id diam. Porta non pulvinar neque laoreet suspendisse interdum. Malesuada fames ac turpis egestas integer eget aliquet nibh. Nullam non nisi est sit amet. Lectus mauris ultrices eros in cursus turpis massa tincidunt dui. Tellus in metus vulputate eu scelerisque. Quisque id diam vel quam elementum pulvinar etiam. Amet purus gravida quis blandit turpis cursus.', 1);
INSERT INTO public.recipes VALUES (2, 'Fancy Pizza', '2023-02-28 17:01:58.891234', 'Perfecto! Arcu odio ut sem nulla pharetra diam sit amet. Sapien nec sagittis aliquam malesuada bibendum arcu vitae elementum curabitur. At elementum eu facilisis sed. Rhoncus urna neque viverra justo nec. Dignissim enim sit amet venenatis urna cursus eget nunc scelerisque. Curabitur vitae nunc sed velit dignissim sodales ut. Egestas quis ipsum suspendisse ultrices gravida dictum fusce ut. Nunc sed blandit libero volutpat. Sed elementum tempus egestas sed sed risus pretium quam vulputate. Urna id volutpat lacus laoreet non curabitur gravida.', 1);
INSERT INTO public.recipes VALUES (1, 'Banana Pancakes', '2023-02-28 16:30:03.079588', 'A yummy treat!

Step 1. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. 

Step 2. Nec nam aliquam sem et tortor consequat id. Posuere sollicitudin aliquam ultrices sagittis orci a. Arcu bibendum at varius vel pharetra vel turpis nunc eget. Turpis egestas sed tempus urna et pharetra pharetra. 

Step 3. Enim blandit volutpat maecenas volutpat blandit. Neque sodales ut etiam sit amet nisl purus in. Phasellus vestibulum lorem sed risus ultricies tristique nulla. Amet cursus sit amet dictum sit amet justo donec. Morbi tincidunt augue interdum velit euismod in pellentesque massa.', 1);


--
-- Data for Name: recipes_shopping_lists; Type: TABLE DATA; Schema: public; Owner: zmorgan
--

INSERT INTO public.recipes_shopping_lists VALUES (2, 2, 1);
INSERT INTO public.recipes_shopping_lists VALUES (3, 2, 2);
INSERT INTO public.recipes_shopping_lists VALUES (6, 1, 3);
INSERT INTO public.recipes_shopping_lists VALUES (9, 2, 7);
INSERT INTO public.recipes_shopping_lists VALUES (10, 1, 7);
INSERT INTO public.recipes_shopping_lists VALUES (11, 3, 8);
INSERT INTO public.recipes_shopping_lists VALUES (14, 3, 10);
INSERT INTO public.recipes_shopping_lists VALUES (15, 3, 11);
INSERT INTO public.recipes_shopping_lists VALUES (16, 3, 13);


--
-- Data for Name: shopping_lists; Type: TABLE DATA; Schema: public; Owner: zmorgan
--

INSERT INTO public.shopping_lists VALUES (1, '2023-02-28 16:26:33.407959', NULL, 1);
INSERT INTO public.shopping_lists VALUES (2, '2023-02-28 17:02:47.769088', NULL, 1);
INSERT INTO public.shopping_lists VALUES (3, '2023-02-28 17:07:27.99036', NULL, 1);
INSERT INTO public.shopping_lists VALUES (4, '2023-03-01 08:59:45.869137', NULL, 1);
INSERT INTO public.shopping_lists VALUES (5, '2023-03-01 09:00:17.527464', NULL, 1);
INSERT INTO public.shopping_lists VALUES (6, '2023-03-01 10:05:02.242242', NULL, 1);
INSERT INTO public.shopping_lists VALUES (7, '2023-03-01 10:12:09.17031', NULL, 1);
INSERT INTO public.shopping_lists VALUES (8, '2023-03-01 13:54:26.055463', NULL, 1);
INSERT INTO public.shopping_lists VALUES (9, '2023-03-01 14:01:24.980971', NULL, 1);
INSERT INTO public.shopping_lists VALUES (10, '2023-03-01 14:05:09.472416', NULL, 1);
INSERT INTO public.shopping_lists VALUES (11, '2023-03-01 14:06:00.745936', NULL, 1);
INSERT INTO public.shopping_lists VALUES (12, '2023-03-01 14:09:45.91567', NULL, 1);
INSERT INTO public.shopping_lists VALUES (13, '2023-03-01 14:13:03.149215', NULL, 1);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: zmorgan
--

INSERT INTO public.users VALUES (1, 'demouser1', '$2a$12$5jIeDBwu5CxegznGGR3F9.Rfbd8DSYofyKk9aJdL2NAZoTnNaF1Eq', 13);


--
-- Name: ingredients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: zmorgan
--

SELECT pg_catalog.setval('public.ingredients_id_seq', 126, true);


--
-- Name: items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: zmorgan
--

SELECT pg_catalog.setval('public.items_id_seq', 134, true);


--
-- Name: recipes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: zmorgan
--

SELECT pg_catalog.setval('public.recipes_id_seq', 4, true);


--
-- Name: recipes_shopping_lists_id_seq; Type: SEQUENCE SET; Schema: public; Owner: zmorgan
--

SELECT pg_catalog.setval('public.recipes_shopping_lists_id_seq', 16, true);


--
-- Name: shopping_lists_id_seq; Type: SEQUENCE SET; Schema: public; Owner: zmorgan
--

SELECT pg_catalog.setval('public.shopping_lists_id_seq', 13, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: zmorgan
--

SELECT pg_catalog.setval('public.users_id_seq', 1, true);


--
-- Name: ingredients ingredients_pkey; Type: CONSTRAINT; Schema: public; Owner: zmorgan
--

ALTER TABLE ONLY public.ingredients
    ADD CONSTRAINT ingredients_pkey PRIMARY KEY (id);


--
-- Name: items items_pkey; Type: CONSTRAINT; Schema: public; Owner: zmorgan
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_pkey PRIMARY KEY (id);


--
-- Name: recipes recipes_pkey; Type: CONSTRAINT; Schema: public; Owner: zmorgan
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT recipes_pkey PRIMARY KEY (id);


--
-- Name: recipes_shopping_lists recipes_shopping_lists_pkey; Type: CONSTRAINT; Schema: public; Owner: zmorgan
--

ALTER TABLE ONLY public.recipes_shopping_lists
    ADD CONSTRAINT recipes_shopping_lists_pkey PRIMARY KEY (id);


--
-- Name: shopping_lists shopping_lists_pkey; Type: CONSTRAINT; Schema: public; Owner: zmorgan
--

ALTER TABLE ONLY public.shopping_lists
    ADD CONSTRAINT shopping_lists_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: zmorgan
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: zmorgan
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: ingredients ingredients_recipe_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: zmorgan
--

ALTER TABLE ONLY public.ingredients
    ADD CONSTRAINT ingredients_recipe_id_fkey FOREIGN KEY (recipe_id) REFERENCES public.recipes(id) ON DELETE CASCADE;


--
-- Name: items items_shopping_list_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: zmorgan
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_shopping_list_id_fkey FOREIGN KEY (shopping_list_id) REFERENCES public.shopping_lists(id) ON DELETE CASCADE;


--
-- Name: recipes_shopping_lists recipes_shopping_lists_recipe_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: zmorgan
--

ALTER TABLE ONLY public.recipes_shopping_lists
    ADD CONSTRAINT recipes_shopping_lists_recipe_id_fkey FOREIGN KEY (recipe_id) REFERENCES public.recipes(id) ON DELETE CASCADE;


--
-- Name: recipes_shopping_lists recipes_shopping_lists_shopping_list_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: zmorgan
--

ALTER TABLE ONLY public.recipes_shopping_lists
    ADD CONSTRAINT recipes_shopping_lists_shopping_list_id_fkey FOREIGN KEY (shopping_list_id) REFERENCES public.shopping_lists(id) ON DELETE CASCADE;


--
-- Name: recipes recipes_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: zmorgan
--

ALTER TABLE ONLY public.recipes
    ADD CONSTRAINT recipes_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: shopping_lists shopping_lists_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: zmorgan
--

ALTER TABLE ONLY public.shopping_lists
    ADD CONSTRAINT shopping_lists_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

