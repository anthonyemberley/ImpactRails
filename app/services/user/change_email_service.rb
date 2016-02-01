class ChangeEmailService < Aldous::Service
	
	def initialize(user,new_email)
		@user = user
		@new_email = new_email
	end

	def perform
		if @user.update_attribute(:email,@new_email)
			Result::Success.new(result: @user)
		else
			Result::Failure.new(errors: @user.errors)
		end
	end
end