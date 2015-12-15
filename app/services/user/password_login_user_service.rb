class PasswordLoginUserService < Aldous::Service
	
	def initialize(login_params)
		@email = login_params[:email]
		@inputted_password = login_params[:password]
		@device_token = login_params[:device_token]
	end

	def perform
		user = User.find_by(email: @email)
		if user && BCrypt::Engine.hash_secret(@inputted_password, user.salt) == user.encrypted_password
			UpdateDeviceTokenService.new(user,@device_token).perform
	   		Result::Success.new(result: user)
		else 
	   		Result::Failure.new(errors: user.errors)
		end
	end
end