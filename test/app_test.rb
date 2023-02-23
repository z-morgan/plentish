# require 'simplecov'
# SimpleCov.start

ENV["RACK_ENV"] = "test"

require 'minitest/autorun'
require 'rack/test'
# require 'fileutils'
require_relative '../app'
require_relative 'postgresdb_setup'

class AppTest < Minitest::Test
  include Rack::Test::Methods
  include PostgresDBSetup

  def app
    Sinatra::Application
  end

  def session
    last_request.env["rack.session"]
  end

  def signed_in
    { "rack.session" => { username: "asdfasdf" } }
  end

  ######## tests #########

  def test_homepage_not_signed_in
    get '/'
    assert_equal 200, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
    assert_includes last_response.body, "id='header-buttons'"
  end

  # def test_homepage_signed_in
  #   get '/', {}, signed_in
  #   assert_equal 302, last_response.status

  #   get last_response["Location"]
  #   assert_equal 200, last_response.status
  #   assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
  #   assert_includes last_response.body, "Mr. Admin's Inventories"
  # end

  def test_register_user
    post '/register', {username: 'testuser1', password1: 'Password123', password2: 'Password123'}
    assert_equal 302, last_response.status
    assert_equal "Account created - You may now sign in", session[:msg]

    get last_response["Location"]
    assert_equal 200, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
    assert_includes last_response.body, "id='header-buttons'"
  end

  def test_register_user_short_name
    post '/register', {username: 'user1', password1: 'Password123', password2: 'Password123'}
    assert_equal 422, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
    assert_includes last_response.body, "Username must be between 8 and 50 characters."
  end

  def test_register_user_long_name
    name = 'user1user1user1user1user1user1user1user1user1user1user1'
    post '/register', {username: name, password1: 'Password123', password2: 'Password123'}
    assert_equal 422, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
    assert_includes last_response.body, "Username must be between 8 and 50 characters."
  end

  def test_register_username_taken
    post '/register', {username: 'testuser1', password1: 'Password123', password2: 'Password123'}
    assert_equal 302, last_response.status
    assert_equal "Account created - You may now sign in", session[:msg]

    post '/register', {username: 'testuser1', password1: 'Password123', password2: 'Password123'}
    assert_equal 422, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
    assert_includes last_response.body, 'That username already exists.'
  end

  def test_register_user_short_password
    post '/register', {username: 'testuser1', password1: 'Pass', password2: 'Pass'}
    assert_equal 422, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
    assert_includes last_response.body, "Password must be between 8 and 50 characters."
  end

  def test_register_user_long_password
    password = 'Password123Password123Password123Password123Password123'
    post '/register', {username: 'testuser1', password1: password, password2: password}
    assert_equal 422, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
    assert_includes last_response.body, "Password must be between 8 and 50 characters."
  end

  def test_register_password_no_uppercase
    post '/register', {username: 'testuser1', password1: 'password123', password2: 'password123'}
    assert_equal 422, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
    assert_includes last_response.body, "Password must contain a number, uppercase letter, and lowercase letter."
  end

  def test_register_password_no_lowercase
    post '/register', {username: 'testuser1', password1: 'PASSWORD123', password2: 'PASSWORD123'}
    assert_equal 422, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
    assert_includes last_response.body, "Password must contain a number, uppercase letter, and lowercase letter."
  end

  def test_register_password_no_numbers
    post '/register', {username: 'testuser1', password1: 'Password', password2: 'Password'}
    assert_equal 422, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
    assert_includes last_response.body, "Password must contain a number, uppercase letter, and lowercase letter."
  end

  def test_signin
    post '/register', {username: 'testuser1', password1: 'Password123', password2: 'Password123'}
    assert_equal 302, last_response.status
    assert_equal "Account created - You may now sign in", session[:msg]

    post '/signin', {username: 'testuser1', password: 'Password123'}
    assert_equal 302, last_response.status

    assert_equal 'http://example.org/my-shopping-list', last_response['Location']
    # get last_response["Location"]
    # assert_equal 200, last_response.status
    # assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
    # assert_includes last_response.body, # something on the page
  end

  def test_my_shopping_list
    get '/my-shopping-list', {}, signed_in
    assert_equal 200, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
    assert_includes last_response.body, "my_shopping_list.js"
  end

  def test_my_shopping_list_not_signed_in
    get '/my-shopping-list'
    assert_equal 302, last_response.status
    assert_equal 'http://example.org/', last_response['Location']
  end

  def test_get_all_items
    get '/my-shopping-list/items', {}, signed_in
    assert_equal 200, last_response.status
    assert_equal "application/json;charset=utf-8", last_response["Content-Type"]
    assert_includes last_response.body, "\"name\":\"Dried Cranberries\""
  end

  def test_recipes
    get '/recipes', {}, signed_in
    assert_equal 200, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
    assert_includes last_response.body, 'javascripts/recipes.js'
  end

  def test_new_recipe
    request_params = {
      'name' => 'Pizza',
      'description' => 'Put in the Oven for 10 minutes.',
      'i-name-1' => 'Cheese',
      'quantity-1' => '25',
      'units-1' => 'oz.',
      'i-name-2' => 'Salami',
      'quantity-2' => '4',
      'units-2' => 'cups'
    }

    post '/recipes', request_params, signed_in
    assert_equal 302, last_response.status

    get last_response["Location"]
    assert_equal 200, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
    assert_includes last_response.body, "Pizza"
  end

  def test_delete_recipe
    delete '/recipes/1', {}, signed_in
    assert_equal 204, last_response.status

    get '/recipes', {}, signed_in
    assert_equal 200, last_response.status
    refute_includes last_response.body, 'Smith Rock Granola'
  end
end