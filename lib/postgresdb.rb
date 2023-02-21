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
end

# puts PostgresDB.new(PG.connect(dbname: 'shopping_list')).username_exists('zmorga')