require "mandrill"

m = Mandrill::API.new

message = {
	:subject=> "Hello from Blog-E",
	:from_name=> "Blog-E",
	:text=> "Thank you for contacting us",
	:to=> [{:email=> "thelovelybones01@gmail.com",
			:name=> "Christine"}],
	:html=> "<html><h1>This is an automatically generated email. Please do not reply to this email. Someone will get in touch within 24-48 hours with an answer to your inquiry. Have a nice day.</h1></html>",
	:from_email=> "thelovelybones01@gmail.com" 
}
sending = m.messages.send (message)
puts sending