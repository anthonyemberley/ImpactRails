class Api::UsersController < Api::ApiController

	def leave_current_cause
		response = LeaveCauseService.new(@current_user).perform
		if response.success?
			message = "Successfully left Cause"
			ApiController.render_success_with_message(:ok,message)
		else
			render_error(:bad_request,response.errors)
		end
	end
	
end
