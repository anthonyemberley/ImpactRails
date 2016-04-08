class CreateUserService < Aldous::Service

	def initialize(user_params)
		@user_params = user_params
		@device_token = user_params[:device_token]
		@email = user_params[:email].downcase
		@name = user_params[:name]
		@password = user_params[:password]
	end

	def perform
		new_user = User.new(
							email: @email,
							name: @name,
							device_token: @device_token,
							password: @password
						)
		if new_user.save
			UpdateDeviceTokenService.new(new_user,@device_token).perform
			Result::Success.new(result: new_user)
		else
			Result::Failure.new(errors: new_user.errors)
		end
	end

end