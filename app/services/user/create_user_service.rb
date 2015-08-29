class CreateUserService < Aldous::Service

	def initialize(user_params)
		@user_params = user_params
	end

	def perform
		new_user = User.new(@user_params)
		if new_user.save
			Result::Success.new(result: new_user)
		else
			Result::Failure.new(errors: new_user.errors)
		end
	end

end