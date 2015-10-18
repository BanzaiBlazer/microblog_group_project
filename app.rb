require 'active_record'
require 'sinatra'
require 'sinatra/activerecord'
require 'rack-flash'
require './models.rb'
require 'mandrill'

set :database, "sqlite3:db/database.sqlite3"

set :sessions,true
use Rack::Flash

m=Mandrill::API.new

def current_user
	if session[:user_id]
		@current_user = User.find(session[:user_id])
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

get "/contactus" do
	erb :contactus
end

get "/profile" do
	if current_user
		erb :profile
	else
		redirect "/home"
	end
end

post "/profile" do
	if !current_user
		flash[:notice] = "You're not signed in."
		redirect "/home"
	else #if fields are not empty, update.
		@user = current_user
		if !params[:username].nil? 
			@user.update(username: params[:username])
		elsif !params[:email].nil? 
			@user.update(email: params[:email])
		elsif !params[:password].nil? 
			@user.update(password: params[:password])
		elsif !params[:firstname].nil? 
			@user.update(firstname: params[:fname])
		elsif !params[:lastname].nil?	
			@user.update(lastname: params[:lname])
		else
			@user.update(
			username: params[:username],
			firstname: params[:fname],
			lastname: params[:lname],
			email: params[:email],
			password: params[:password])
		end
	end 
	redirect "/profile"
end

# post "/login" do
# 	@user = User.where(username: params[:username]).first
# 	if @user && @user.password == params[:password]
# 		session[:user_id] = @user.id
# 		flash[:notice] = "You logged in!"
# 	else
# 		flash[:alert] = "We could not log you in..."
# 	end
# 	redirect "/home"
# end

get "/sign_out" do
	flash[:notice] = "You just signed out!"
	session.clear
	redirect to("/sign_out_successful")
end

post "/user_create" do
	if params[:username].empty? ||
		params[:email].empty? ||
		params[:password].empty? ||
		params[:firstname].empty? ||
		params[:lastname].empty?
		redirect to("/user_create_error")
	else
		User.create({
			:username => params[:username],
			:email => params[:email],
			:password => params[:password],
			:firstname => params[:firstname],
			:lastname => params[:lastname]
		})
		redirect to("/home")
	end
end

get "/user_create_error" do
	"You did not fill out the form correctly"
end	

get "/sign_out_successful" do
	"Sign out successful"
end

get "/contact" do
	erb :contact
end

post "/contact" do
	message = {
		:subject=> "#{params[:subject]}",
		:from_name=> "#{params[:name]}",
		:text=> "#{params[:body]}",
		:to=>[{:email=> "bloge@hotmail.com",
				:name=> "bloge"}],
		:html=>"<html>#{params[:body]}</html>",
		:from_email=> "#{params[:email]}"
	}
	sending = m.messages.send (message)
	print sending
end