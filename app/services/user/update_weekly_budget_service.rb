class UpdateWeeklyBudgetService < Aldous::Service
	
	def initialize(params, user)
		@value = params[:value]
		@value = @value.to_f
		@value = @value*100
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
		@user.update_attribute(:weekly_budget, @value.to_i) 
	end

end