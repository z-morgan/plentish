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
    status[:is_valid] = true;
  end

  status
end

before do
  @db = init_db
  redirect '/' unless (request.path_info =~ /(^\/$|signin|register)/) || session[:username]
end

after do
  @db.disconnect
end

### Routes ###

get '/' do
  @overlay_class = 'hidden'
  @register_class = 'hidden'
  @signin_class = 'hidden'
  erb :home, :layout => false;
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
    erb :home, :layout => false;
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
  erb :home, :layout => false;
end

get '/my-shopping-list' do
  erb :my_shopping_list
end

get '/my-shopping-list/items' do
  items_array = @db.retrieve_items(session[:username]);
  headers["Content-Type"] = "application/json;charset=utf-8"
  JSON.generate(items_array)
end

get '/recipes' do
  erb :recipes
end

get '/recipes/id' do
  erb :recipe_details
end
