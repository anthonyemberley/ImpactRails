class UpdateWeeklyBudgetService < Aldous::Service
	
	def initialize(params, user)
		@value = params[:value]
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
		@user.update_attribute(:weekly_budget, @value.to_f) 
	end

end