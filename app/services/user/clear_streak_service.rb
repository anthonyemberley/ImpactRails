class ClearStreakService < Aldous::Service
	
	def initialize(user)
		@user = user
	end

	def perform
		update_user
		if @user
			Result::Success.new(result: @user)
		else
			Result::Failure.new(errors: @user.errors)
		end
	end

	private 

	def update_user
		@user.update_attribute(:current_streak, 0)
	end

end