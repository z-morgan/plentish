require 'pg'

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
  end

  def disconnect
    @connection.close
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

  def retrieve_items(username)
    sql = <<~SQL
      SELECT name, quantity, units, done, pantry
      FROM items
      WHERE shopping_list_id = (
        SELECT current_list_id FROM users
        WHERE username = $1
      );
    SQL

    items = [];
    @connection.exec_params(sql, [username]).each do |item|
      item['quantity'] = item['quantity'].to_i      # abstract this to helper method?
      item['pantry'] = item['pantry'] == 't'
      item['done'] = item['done'] == 't'
      items.push(item)
    end
    items
  end

  def retrieve_recipes(username)
    sql = <<~SQL
      SELECT r.id, r.name, r.date_created, rs.id AS list_id FROM recipes AS r
      LEFT JOIN recipes_shopping_lists AS rs ON r.id = rs.recipe_id
      AND rs.shopping_list_id = (
        SELECT current_list_id FROM users
        WHERE username = $1
      );
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
      ingredient['quantity'] = ingredient['quantity'].to_i
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
  end

  def create_recipe(username, name, description)
    sql = <<~SQL
      INSERT INTO recipes
      (name, description, user_id)
      VALUES ($2, $3, (SELECT id FROM users WHERE username = $1));
    SQL

    @connection.exec_params(sql, [username, name, description])
    @connection.exec('SELECT lastval()').values[0][0].to_i
  end

  def create_ingredient(ingredient, recipe_id)
    name = ingredient['name']
    quantity = ingredient['quantity']
    units = ingredient['units']

    sql = <<~SQL
      INSERT INTO ingredients
      (name, quantity, units, recipe_id)
      VALUES ($1, $2, $3, $4);
    SQL

    @connection.exec_params(sql, [name, quantity, units, recipe_id])
  end

  private

  def format_date(date)
    parts = date.split('-')
    parts[1] = parts[1][1] if parts[1][0] == '0'
    parts[2] = parts[2][1] if parts[2][0] == '0'
    parts[0] = parts[0][2..3]
    "#{parts[1]}/#{parts[2]}/#{parts[0]}"
  end
end

# puts PostgresDB.new(PG.connect(dbname: 'shopping_list')).username_exists('zmorga')