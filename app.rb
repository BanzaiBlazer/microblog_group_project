require 'active_record'
require 'sinatra'
require 'sinatra/activerecord'
require 'rack-flash'
require './models.rb'

set :database, "sqlite3:db/database.sqlite3"

set :sessions,true
use Rack::Flash

def current_user
	if session[:user_id]
		@current_user = User.find(session[:user_id])
		return true
	else
		return false
	end
end

get "/home" do
	@allpost = Post.all
	erb :home
end
post "/home" do
	@newpost = Post.create({
		user_id: session[:user_id],
		title: params[:title], 
		body: params[:body]})
	redirect "/home"
end
get "/sign_up" do
	erb :sign_up
end

get "/profile" do
	if current_user == true
		erb :profile
	else
		redirect "/home"
	end
end

post "/profile" do
	redirect "/profile"
	
end

post "/login" do
	@user = User.where(username: params[:username]).first
	if @user && @user.password == params[:password]
		session[:user_id] = @user.id
		flash[:notice] = "You logged in!"
	else
		flash[:alert] = "Could not log you in..."
	end
	redirect "/home"
end

get "/logout" do
	flash[:notice] = "You've just logged out!"
	session.clear
	redirect to("/logout_successful")
end

post "/user_create" do
	# if params[:username].empty? ||
	# 	params[:email].empty? ||
	# 	params[:password].empty?
	# 	redirect to("/user_create_error")
	# else
	User.create({
		:username => params[:username],
		:email => params[:email],
		:password => params[:password]
	})
	redirect to("/home")
	# end
end

get "/user_create_error" do
	"You did not fill out the form correctly"
end	

get "/logout_successful" do
	"Logout successful"
end


