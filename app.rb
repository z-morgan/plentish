require 'sinatra'

unless ENV["RACK_ENV"] == "production"
  set :server, ['webrick', 'puma']
  set :port, 4000
end

require 'sinatra/reloader' if development?
require 'tilt/erubis' # remove tilt?
require 'bcrypt'
require 'securerandom'
require 'json'

require_relative 'lib/postgresdb'

configure do
  enable :sessions
  set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }
  set :erb, :escape_html => true
end

configure :development do
  also_reload 'lib/postgresdb.rb'
end

### Route Helpers ###

def validate_creds(u_name, pass)
  status = {is_valid: false}

  if u_name.length < 8 || u_name.length > 50
    status[:error_msg] = 'Username must be between 8 and 50 characters.'
  elsif @db.username_exists(u_name)
    status[:error_msg] = 'That username already exists.'
  elsif pass.length < 8 || pass.length > 50
    status[:error_msg] = 'Password must be between 8 and 50 characters.'
  elsif !(pass =~ /[a-z]/ && pass =~ /[A-Z]/ && pass =~ /\d/)
    status[:error_msg] = 'Password must contain a number, uppercase letter, and lowercase letter.'
  else
    status[:is_valid] = true
  end

  status
end

def valid_recipe(fields)
  fields.none? { |_, v| v == '' || v.class != String }
end

def collect_ingredients(params)
  max = params.keys.reduce(0) do |acc, key|
    match = key.match(/\d+$/)
    num = 0
    if match
      num = match[0].to_i
    end
    num > acc ? num : acc
  end

  ingredients = []
  1.upto(max) do |num|
    if params["i-name-#{num.to_s}"]
      ingredient = {}
      ingredient['name'] = params["i-name-#{num.to_s}"]
      ingredient['quantity'] = params["quantity-#{num.to_s}"]
      ingredient['units'] = params["units-#{num.to_s}"]
      ingredients.push(ingredient)
    end
  end
  ingredients
end

before do
  @db = init_db
  unless session[:username] || (request.path_info =~ /(^\/$|signin|register)/)
    # eventually change this to a 401 with an `WWW-Authenticate` header 
    redirect '/'
  end
end

after do
  @db.disconnect
end

### Routes ###

get '/' do
  @overlay_class = 'hidden'
  @register_class = 'hidden'
  @signin_class = 'hidden'
  erb :home, :layout => false
end

post '/register' do
  username = params[:username]
  password1 = params[:password1]
  @status = validate_creds(username, password1)

  if @status[:is_valid]
    @db.create_user(params[:username], params[:password1])
    session[:msg] = 'Account created - You may now sign in'
    redirect '/'
  else
    @overlay_class = ''
    @register_class = ''
    @signin_class = 'hidden'
    status 422
    erb :home, :layout => false
  end
end

post '/signin' do
  username = params[:username]
  password = params[:password]
  @overlay_class = ''
  @register_class = 'hidden'
  @signin_class = ''
  @status = {is_valid: false}

  if @db.username_exists(username)
    if @db.correct_password(username, password)
      session[:username] = username
      redirect '/my-shopping-list'
    else
      @status[:error_msg] = 'That password is incorrect'
    end
  else
    @status[:error_msg] = 'That username does not exist'
  end

  status 422
  erb :home, :layout => false
end

get '/my-shopping-list' do
  erb :my_shopping_list
end

get '/my-shopping-list/items' do
  items_array = @db.retrieve_items(session[:username])
  headers["Content-Type"] = "application/json;charset=utf-8"
  JSON.generate(items_array)
end

get '/recipes' do
  @recipes = @db.retrieve_recipes(session[:username])
  erb :recipes
end

post '/recipes' do
  if valid_recipe(params)
    recipe_id = @db.create_recipe(session[:username], params[:name], params[:description])
    ingredient_objects = collect_ingredients(params)
    ingredient_objects.each do |ingredient|
      @db.create_ingredient(ingredient, recipe_id)
    end
    redirect '/recipes'
  else
    status 422
    @recipes = @db.retrieve_recipes(session[:username])
    erb :recipes
  end
end

get '/recipes/:id' do
  @recipe = @db.retrieve_recipe(params[:id])
  @ingredients = @db.retrieve_recipe_ingredients(params[:id])
  @ingredients.each_with_index { |ingredient, i| ingredient['number'] = (i + 1).to_s }
  erb :recipe_details
end

put '/recipes/:id' do
  if request.media_type == 'application/json'
    body_obj = JSON.parse(request.body.read)
    if body_obj['selected']
      @db.select_recipe(session[:username], params[:id])
    else
      @db.deselect_recipe(session[:username], params[:id])
    end
    status 204
  else
    # something else?
  end
end

post '/recipes/:id' do
  if @db.recipe_is_selected?(session[:username], params[:id])
    @db.deselect_recipe(session[:username], params[:id])
    
    @db.update_recipe(params[:id], params[:name], params[:description])

    @db.delete_all_ingredients(params[:id])
    ingredient_objects = collect_ingredients(params)
    ingredient_objects.each do |ingredient|
      @db.create_ingredient(ingredient, params[:id])
    end

    @db.select_recipe(session[:username], params[:id])
  else
    @db.update_recipe(params[:id], params[:name], params[:description])

    @db.delete_all_ingredients(params[:id])
    ingredient_objects = collect_ingredients(params)
    ingredient_objects.each do |ingredient|
      @db.create_ingredient(ingredient, params[:id])
    end
  end

  redirect "recipes/#{params[:id]}"
end

delete '/recipes/:id' do
  @db.delete_recipe(params[:id])
  status 204
end
