class User < ActiveRecord::Base
	# def makeFullname
	# 	# :fullname = User.firstname + " " + User.lastname
	# end
	def isSecurePassword
		!self.password.nil? &&
		self.password > 6 &&
		self.password < 15 &&
		!self.password.match("[0-9]").nil?
	end
end