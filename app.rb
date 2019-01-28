require "sinatra"
require "sinatra/reloader" if development?
require "pry-byebug"
require "better_errors"
require_relative "cookbook"
require_relative "recipe"
require_relative "scraper"

set :bind, '0.0.0.0'
enable :sessions

configure :development do
  use BetterErrors::Middleware
  BetterErrors.application_root = File.expand_path('..', __FILE__)
end

get '/' do
  csv_file = File.join(__dir__, '/recipes.csv')
  cookbook = Cookbook.new(csv_file)
  @recipes = cookbook.all
  erb :index
end

get '/new' do
  erb :new
end

post '/recipes' do
  csv_file = File.join(__dir__, '/recipes.csv')
  @cookbook = Cookbook.new(csv_file)
  @cookbook.add_recipe(Recipe.new(params[:name], params[:description], params[:time], params[:difficulty]))
  redirect '/'
end

get '/import' do
  erb :import
end

post '/import' do
  session[:recipe_list] = Scraper.new(params[:ingredient], params[:difficulty])
  redirect '/list_import'
end

get '/list_import' do
  @scraped_titles = session[:recipe_list].scraped_titles
  erb :list_import
end

get '/import_select' do
  csv_file = File.join(__dir__, '/recipes.csv')
  @cookbook = Cookbook.new(csv_file)
  @title_import = session[:recipe_list].scraped_titles[params[:index].to_i - 1]
  @description_import = session[:recipe_list].scraped_description[params[:index].to_i - 1]
  @time_import = session[:recipe_list].scraped_time[params[:index].to_i - 1]
  @difficulty_import = session[:recipe_list].scraped_difficulty[params[:index].to_i - 1]
  @cookbook.add_recipe(Recipe.new(@title_import, @description_import, @time_import, @difficulty_import))
  redirect '/'
end

get '/delete' do
  csv_file = File.join(__dir__, '/recipes.csv')
  @cookbook = Cookbook.new(csv_file)
  @cookbook.remove_recipe(params[:index].to_i)
  redirect '/'
end

get '/done' do
  csv_file = File.join(__dir__, '/recipes.csv')
  @cookbook = Cookbook.new(csv_file)
  @remove = @cookbook.find(params[:index_done].to_i)
  @remove.recipe_read!
  @cookbook.save
  redirect '/'
end

get '/about' do
  erb :about
end

get '/team/:username' do
  puts params[:username]
  "The username is #{params[:username]}"
end
