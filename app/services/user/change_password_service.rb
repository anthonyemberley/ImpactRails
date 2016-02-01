class ChangePasswordService < Aldous::Service
	
	def initialize(user,new_password)
		@user = user
		@new_password = new_password
	end

	def perform
		new_encrypted_password = BCrypt::Engine.hash_secret(@new_password, @user.salt)
		if @user.update_attribute(:encrypted_password,new_encrypted_password)
			Result::Success.new(result: @user)
		else
			Result::Failure.new(errors: @user.errors)
		end
	end
end