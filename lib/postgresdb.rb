require 'pg'

require_relative 'demo_account'


### Database Startup method ###

def init_db
  connection = if Sinatra::Base.production?
                 PG.connect(ENV['DATABASE_URL'])
               elsif Sinatra::Base.test?
                 PG.connect(dbname: "shopping_list_test")
               else
                 PG.connect(dbname: "shopping_list")
               end
               
  PostgresDB.new(connection)
end

class PostgresDB
  def initialize(connection)
    @connection = connection
    @demo_account = DemoAccount.new(@connection)
  end

  def disconnect
    @connection.close
  end

  def demo_account_signin
    @demo_account.signin
  end

  def demo_account_duration(username)
    @demo_account.time_since_login(username)
  end

  def create_user(username, password)
    unless ENV["RACK_ENV"] == "test"
      password = BCrypt::Password.create(password)
    end

    sql = <<~SQL
      INSERT INTO users (username, password)
      VALUES ($1, $2);
    SQL

    @connection.exec_params(sql, [username, password])
  end

  def username_exists(username)
    sql = "SELECT 1 FROM users WHERE username = $1;"
    !(@connection.exec_params(sql, [username]).values.empty?)
  end

  def correct_password(username, attempt_pw)
    sql = "SELECT password FROM users WHERE username = $1;"
    real_pw = @connection.exec_params(sql, [username]).values[0][0]

    if ENV["RACK_ENV"] == "test"
      real_pw == attempt_pw
    else
      BCrypt::Password.new(real_pw) == attempt_pw
    end
  end

  def create_shopping_list(username)
    sql = <<~SQL
      INSERT INTO shopping_lists
      (user_id) 
      VALUES ((SELECT id FROM users WHERE username = $1))
      RETURNING id;
    SQL

    @connection.exec_params(sql, [username]).values[0][0];
  end

  def update_current_list(username, list_id)
    sql = <<~SQL
      UPDATE users
      SET current_list_id = $2
      WHERE id = (SELECT id FROM users WHERE username = $1);
    SQL

    @connection.exec_params(sql, [username, list_id])
  end

  def retrieve_archive(username)
    sql = <<~SQL
      SELECT id, date_created FROM shopping_lists
      WHERE user_id = (SELECT id FROM users WHERE username = $1)
        AND id <> (SELECT current_list_id FROM users WHERE username = $1)
      ORDER BY date_created DESC;
    SQL

    archive = [];
    @connection.exec_params(sql, [username]).each do |list|
      list['date_created'] = format_date(list['date_created'])
      archive.push(list);
    end
    archive
  end

  def retrieve_suggested_items(username, prefix, count = 8)
    sql = <<~SQL
      SELECT i.name, i.units FROM items AS i
      LEFT JOIN shopping_lists AS s ON s.id = i.shopping_list_id
      WHERE s.user_id = (SELECT id FROM users WHERE username = $1)
      GROUP BY name, units
      HAVING name SIMILAR TO CONCAT($2::text, '%')
      LIMIT $3;
    SQL

    items = [];
    @connection.exec_params(sql, [username, prefix, count]).each do |item|
      items.push(item);
    end
    items
  end

  def retrieve_unique_items_by_list(list_id)
    sql = <<~SQL
      SELECT name, units FROM items
      WHERE shopping_list_id = $1
      GROUP BY name, units;
    SQL

    items = [];
    @connection.exec_params(sql, [list_id]).each do |item|
      items.push(item);
    end
    items
  end

  def retrieve_items_current_list(username)
    sql = <<~SQL
      SELECT id, name, quantity, units, done, deleted
      FROM items
      WHERE shopping_list_id = (
        SELECT current_list_id FROM users
        WHERE username = $1
      );
    SQL

    process_items(@connection.exec_params(sql, [username]))
  end

  def adjust_item_quantity(item_id, change)
    change = change.to_i
    if change > 0
      increment_item_by(item_id, change)
    else
      decrement_item_by(item_id, -change)
    end
  end

  def update_deleted_state(item_id, newState)
    sql = <<~SQL
      SELECT name, units FROM items WHERE id = $1;
    SQL
    nameUnits = @connection.exec_params(sql, [item_id]).values[0]

    sql = <<~SQL
      SELECT id, quantity FROM items
      WHERE name = $1 AND units = $2 AND deleted = $3;
    SQL
    idQuant = @connection.exec_params(sql, [nameUnits[0], nameUnits[1], newState]).values[0];

    if idQuant
      sql = <<~SQL
        DELETE FROM items
        WHERE id = $1;
      SQL
      @connection.exec_params(sql, [idQuant[0]])
    else
      idQuant = [nil, 0]
    end

    sql = <<~SQL
      UPDATE items
      SET deleted = $2, quantity = quantity + $3
      WHERE id = $1;
    SQL
    @connection.exec_params(sql, [item_id, newState, idQuant[1]]);
  end

  def update_done_state(item_id, newState)
    sql = <<~SQL
      UPDATE items
      SET done = $2
      WHERE id = $1;
    SQL

    @connection.exec_params(sql, [item_id, newState]);
  end

  def retrieve_recipes(username)
    sql = <<~SQL
      SELECT r.id, r.name, r.date_created, rs.id AS list_id
      FROM (SELECT id, recipe_id FROM recipes_shopping_lists WHERE shopping_list_id = (
        SELECT current_list_id FROM users WHERE username = $1
      )) AS rs
      RIGHT JOIN recipes AS r ON r.id = rs.recipe_id
      WHERE r.user_id = (
        SELECT id FROM users
        WHERE username = $1
      )
      ORDER BY r.date_created ASC;
    SQL

    recipes = [];
    @connection.exec_params(sql, [username]).each do |recipe|
      recipe['date_created'] = format_date(recipe['date_created'])
      recipe['selected'] = true if recipe['list_id']
      recipe.delete('list_id')
      recipes.push(recipe)
    end
    recipes
  end

  def retrieve_recipe(recipe_id)
    sql = <<~SQL
      SELECT id, name, date_created, description FROM recipes
      WHERE id = $1; 
    SQL

    recipe = nil;
    @connection.exec_params(sql, [recipe_id]).each do |recipe_hsh|
      recipe_hsh['date_created'] = format_date(recipe_hsh['date_created'])
      recipe = recipe_hsh
    end
    recipe
  end

  def retrieve_recipe_ingredients(recipe_id)
    sql = <<~SQL
      SELECT id, name, quantity, units FROM ingredients
      WHERE recipe_id = $1;
    SQL

    ingredients = [];
    @connection.exec_params(sql, [recipe_id]).each do |ingredient|
      ingredient['quantity'] = ingredient['quantity'].to_f
      ingredients.push(ingredient)
    end
    ingredients
  end

  def select_recipe(username, recipe_id)
    sql = <<~SQL
      INSERT INTO recipes_shopping_lists
      (recipe_id, shopping_list_id)
      VALUES ($2, (
        SELECT current_list_id FROM users
        WHERE username = $1
      ));
    SQL

    @connection.exec_params(sql, [username, recipe_id])

    add_items_to_shopping_list(username, recipe_id)
  end

  def deselect_recipe(username, recipe_id)
    sql = <<~SQL
      DELETE FROM recipes_shopping_lists
      WHERE recipe_id = $2 AND shopping_list_id = (
        SELECT current_list_id FROM users
        WHERE username = $1
      );
    SQL

    @connection.exec_params(sql, [username, recipe_id])

    remove_items_from_shopping_list(username, recipe_id)
  end

  def create_recipe(username, name, description)
    sql = <<~SQL
      INSERT INTO recipes
      (name, description, user_id)
      VALUES ($2, $3, (SELECT id FROM users WHERE username = $1));
    SQL

    @connection.exec_params(sql, [username, format_name(name), description])
    @connection.exec('SELECT lastval()').values[0][0].to_i
  end

  def create_ingredient(ingredient, recipe_id)
    name = format_name(ingredient['name'])
    quantity = ingredient['quantity']
    units = ingredient['units']

    sql = <<~SQL
      INSERT INTO ingredients
      (name, quantity, units, recipe_id)
      VALUES ($1, $2, $3, $4);
    SQL

    @connection.exec_params(sql, [name, quantity, units, recipe_id])
  end

  def update_recipe(recipe_id, name, description)
    sql = <<~SQL
      UPDATE recipes
      SET name = $2, description = $3
      WHERE id = $1;
    SQL

    @connection.exec_params(sql, [recipe_id, format_name(name), description])
  end

  def delete_all_ingredients(recipe_id)
    sql = <<~SQL
      DELETE FROM ingredients
      WHERE recipe_id = $1;
    SQL

    @connection.exec_params(sql, [recipe_id])
  end

  def delete_recipe(recipe_id)
    sql = <<~SQL
      DELETE FROM recipes WHERE id = $1;
    SQL

    @connection.exec_params(sql, [recipe_id])
  end

  def recipe_is_selected?(username, recipe_id)
    sql = <<~SQL
      SELECT * FROM recipes_shopping_lists
      WHERE recipe_id = $2 AND shopping_list_id = (
        SELECT current_list_id FROM users
        WHERE username = $1
      );
    SQL

    !@connection.exec_params(sql, [username, recipe_id]).values.empty?
  end

  def add_custom_item(username, item_details)
    name = item_details['name']
    quantity = item_details['quantity']
    units = item_details['units']

    item_id = item_id_if_exists(username, name, units)
    if item_id
      increment_item_by(item_id, quantity)
    else
      insert_item(username, item_details)
    end
  end

  private

  def process_items(result)
    items = [];
    result.each do |item|
      item['quantity'] = item['quantity'].to_f
      item['deleted'] = item['deleted'] == 't'
      item['done'] = item['done'] == 't'
      items.push(item)
    end
    items
  end

  def format_date(date)
    parts = date.match(/\S+ /)[0].strip.split('-')
    parts[1] = parts[1][1] if parts[1][0] == '0'
    parts[2] = parts[2][1] if parts[2][0] == '0'
    parts[0] = parts[0][2..3]
    "#{parts[1]}/#{parts[2]}/#{parts[0]}"
  end

  def format_name(str)
    str.strip.split(' ').map(&:capitalize).join(' ')
  end

  def add_items_to_shopping_list(username, recipe_id)
    ingredients = retrieve_recipe_ingredients(recipe_id)
    ingredients.each do |ingredient|
      item_id = item_id_if_exists(username, ingredient['name'], ingredient['units'])
      if item_id
        increment_item_by(item_id, ingredient['quantity'])
      else
        insert_item(username, ingredient)
      end
    end
  end

  def remove_items_from_shopping_list(username, recipe_id)
    ingredients = retrieve_recipe_ingredients(recipe_id)
    ingredients.each do |ingredient|
      item_id = item_id_if_exists(username, ingredient['name'], ingredient['units'])
      decrement_item_by(item_id, ingredient['quantity']) if item_id
    end
  end

  def item_id_if_exists(username, name, units)
    sql = <<~SQL
      SELECT id FROM items
      WHERE name = $2
        AND units = $3
        AND deleted = false
        AND shopping_list_id = (
          SELECT current_list_id FROM users
          WHERE username = $1
        );
    SQL

    item = @connection.exec_params(sql, [username, format_name(name), units]).values[0]
    item ? item[0] : nil
  end

  def increment_item_by(item_id, quantity)
    sql = <<~SQL
      UPDATE items
      SET quantity = quantity + $2
      WHERE id = $1
      RETURNING id, name, quantity, units, done, deleted;
    SQL

    process_items(@connection.exec_params(sql, [item_id, quantity]))[0]
  end

  def insert_item(username, ingredient)
    name = format_name(ingredient['name'])
    quantity = ingredient['quantity']
    units = ingredient['units']

    sql = <<~SQL
      INSERT INTO items
      (name, quantity, units, shopping_list_id)
      VALUES ($2, $3, $4, (
        SELECT current_list_id FROM users
        WHERE username = $1
      ))
      RETURNING id, name, quantity, units, done, deleted;
    SQL

    process_items(@connection.exec_params(sql, [username, name, quantity, units]))[0]
  end

  def decrement_item_by(item_id, quantity)
    sql = <<~SQL
      SELECT quantity FROM items WHERE id = $1;
    SQL

    item_quant = @connection.exec_params(sql, [item_id]).values[0][0].to_f

    if item_quant <= quantity
      update_deleted_state(item_id, true)
    else
      sql = <<~SQL
        UPDATE items
        SET quantity = quantity - $2
        WHERE id = $1
      SQL

      @connection.exec_params(sql, [item_id, quantity])
    end
  end
end
