require_relative '../data/demo_seed_data'

class DemoAccount
  def initialize(connection)
    @connection = connection
  end

  def signin
    id, username = oldest_demo_account
    update_last_login_time(id)
    delete_demo_account_data(id)
    add_demo_seed_data(id)
    username
  end

  def time_since_login(username)
    sql = <<~SQL
      SELECT last_login_time FROM users
      WHERE username = $1;
    SQL
    last_login = @connection.exec_params(sql, [username]).values[0][0]
    last_login = time_to_ruby(last_login)

    sql = <<~SQL
      SELECT LOCALTIMESTAMP FROM users;
    SQL
    now = @connection.exec_params(sql).values[0][0]
    now = time_to_ruby(now)

    now.to_i - last_login.to_i
  end

  private

  def time_to_ruby(iso_str)
    time_parts = iso_str.gsub(/[\-:]/, ' ').split(' ').map(&:to_i)
    Time.new(*time_parts)
  end

  def oldest_demo_account
    sql = <<~SQL
      SELECT id, username FROM users
      WHERE last_login_time IS NOT NULL
      ORDER BY last_login_time ASC
      LIMIT 1;
    SQL
    @connection.exec_params(sql).values[0]
  end

  def update_last_login_time(id)
    sql = <<~SQL
      UPDATE users 
      SET last_login_time = LOCALTIMESTAMP
      WHERE id = $1;
    SQL
    @connection.exec_params(sql, [id])
  end

  def delete_demo_account_data(id)
    sql1 = <<~SQL
      UPDATE users SET current_list_id = NULL WHERE id = $1;
    SQL

    sql2 = <<~SQL
      DELETE FROM recipes WHERE user_id = $1;
    SQL

    sql3 = <<~SQL
      DELETE FROM shopping_lists WHERE user_id = $1;
    SQL

    @connection.exec_params(sql1, [id])
    @connection.exec_params(sql2, [id])
    @connection.exec_params(sql3, [id])
  end

  def add_demo_seed_data(id)
    list_id = add_current_shopping_list(id)
    recipe_ids = add_recipes(id)
    add_ingredients(recipe_ids)
    select_recipe(recipe_ids[2], list_id)
    archived_list_ids = add_archived_shopping_lists(id)
    add_items([list_id, *archived_list_ids])
  end

  def add_current_shopping_list(id)
    sql = <<~SQL
      INSERT INTO shopping_lists (user_id) 
      VALUES ($1) RETURNING id;
    SQL
    list_id = @connection.exec_params(sql, [id]).values[0][0]

    sql = <<~SQL
      UPDATE users
      SET current_list_id = $2
      WHERE id = $1;
    SQL
    @connection.exec_params(sql, [id, list_id])
    list_id
  end

  def add_recipes(id)
    sql = <<~SQL
      INSERT INTO recipes (name, description, user_id) 
      VALUES ($1, $2, $3) RETURNING id;
    SQL

    RECIPES.map do |name, description|
      @connection.exec_params(sql, [name, description, id]).values[0][0]
    end
  end

  def add_ingredients(recipe_ids)
    sql = <<~SQL
      INSERT INTO ingredients (name, quantity, units, recipe_id) VALUES ($1, $2, $3, $4);
    SQL

    ingredients = INGREDIENTS.map do |ingredient|
      ingredient = ingredient.dup
      ingredient[3] = recipe_ids[ingredient[3]]
      ingredient
    end

    ingredients.each do |ingredient|
      @connection.exec_params(sql, ingredient)
    end
  end

  def select_recipe(recipe_id, list_id)
    sql = <<~SQL
      INSERT INTO recipes_shopping_lists
      (recipe_id, shopping_list_id)
      VALUES ($1, $2);
    SQL
    @connection.exec_params(sql, [recipe_id, list_id])
  end

  def add_archived_shopping_lists(user_id)
    sql = <<~SQL
      INSERT INTO shopping_lists (date_created, user_id) VALUES ($1, $2) RETURNING id;
    SQL

    ARCHIVED_LISTS.map do |timestamp|
      @connection.exec_params(sql, [timestamp, user_id]).values[0][0]
    end
  end

  def add_items(list_ids)
    sql1 = <<~SQL
      INSERT INTO items (name, quantity, units, deleted, done, shopping_list_id)
      VALUES ($1, $2, $3, $4, $5, $6);
    SQL

    current_list_items = CURRENT_LIST_ITEMS.map do |item|
      item = item.dup
      item[5] = list_ids[0]
      item
    end

    current_list_items.each do |item|
      @connection.exec_params(sql1, item)
    end

    sql2 = <<~SQL
      INSERT INTO items (name, quantity, units, shopping_list_id)
      VALUES ($1, $2, $3, $4);
    SQL

    archived_list_items = ARCHIVED_LIST_ITEMS.map do |item|
      item = item.dup
      item[3] = list_ids[item[3]]
      item
    end

    archived_list_items.each do |item|
      @connection.exec_params(sql2, item)
    end
  end
end
