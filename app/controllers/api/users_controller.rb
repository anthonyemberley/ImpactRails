class Api::UsersController < Api::ApiController
	USER_RESPONSE_KEY = "user"

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
		response = UpdateWeeklyBudgetService.new(update_weekly_budget_params, @current_user).perform
		if response.success?
			render_default_user_response(@current_user)
		else
			render_error(:unauthorized, response.errors)
		end
	end

	def update_automatic_donations
		response = UpdateAutomaticDonationsService.new(@current_user).perform
		if response.success?
		 	render_default_user_response(@current_user)
		else
		 	render_error(:unauthorized, response.errors)
		end

	end


	def change_password
		 new_password = params[:change][:password]
		 response = ChangePasswordService.new(@current_user,new_password).perform
		 if response.success?
		 	render_default_user_response(@current_user)
		 else
		 	render_error(:unauthorized, response.errors)
		 end
	end

	def change_email
		new_email = params[:change][:email]
		response = ChangeEmailService.new(@current_user,new_email).perform
		if response.success?
		 	render_default_user_response(@current_user)
		else
		 	render_error(:unauthorized, response.errors)
		end
	end

	def clear_pending_contribution
		response = ClearPendingContributionService.new(@current_user).perform
		if response.success?
			render_default_user_response(@current_user)
		else
			render_error(:unauthorized, response.errors)
		end
	end

	def clear_streak
		response = ClearStreakService.new(@current_user).perform
		if response.success?
			render_default_user_response(@current_user)
		else
			render_error(:unauthorized, response.errors)
		end
	end

	private
	'''PARAMS'''

		def update_weekly_budget_params
		    params.require(USER_RESPONSE_KEY).permit(:value)
		end

	'''RENDER'''
	    def render_default_user_response(user)
	    	render status: :ok , json: user.as_json
		end
		
end
