class LogoutService < Aldous::Service
	def initialize(user)
		@user = user
	end

	def perform
		new_token = SecureRandom.urlsafe_base64(25).tr('lIO0', 'sxyz')
		if @user.update_attribute(:authentication_token, new_token)
			Result::Success.new
		else
			Result::Failure.new(errors: @user.errors)
		end
	end
end