$LOAD_PATH.unshift(File.expand_path('.'))

require 'securerandom'
require 'sinatra'
require 'sinatra/activerecord'
require 'bcrypt'

require './models/user'


begin
  require 'dotenv'
  Dotenv.load
  rescue LoadError
end

enable :sessions

set :database, ENV['DATABASE_URL']

get '/' do
  @user = current_user
  erb :index
end

def current_user
  @current_user ||= logged_in? && User.find( session[:user_id] )
end

def logged_in?
  session[:user_id]
end

def enforce_login
  redirect_to '/' if !logged_in?
end


post '/login' do
  if @user = User.authenticate(params[:username], params[:password])
    session[:user_id] = @user.id
    redirect "/user/#{@user.username}"
  else
    redirect "/"
  end
end


get '/users/new' do
  erb :form_register
end

post '/users/create' do
  @user = User.create!(params[:user]);
  session[:user_id] = @user.id
  redirect "/user/#{@user.username}"
end

get 'user/:username' do
  Hello! @current_user.username
end

post '/logout' do
  session.clear
  redirect '/'
end

