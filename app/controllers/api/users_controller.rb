class Api::UsersController < Api::ApiController

	def leave_current_cause
		response = LeaveCauseService.new(@current_user).perform
		if response.success?
			message = "Successfully left Cause"
			render_success_with_message(:ok,message)
		else
			render_error(:bad_request,response.errors)
		end
	end

	def update_weekly_budget
		response = UpdateWeeklyBudgetService.new(@current_user, update_weekly_budget_params)
		if response.success?
			render_default_user_response(@current_user)
		else
			render_error(:unauthorized, response.errors)
	end



	private
	'''PARAMS'''


		def update_weekly_budget_params
		    	params.require(USER_RESPONSE_KEY).permit(:value)
		end
		
end
