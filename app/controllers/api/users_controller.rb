class Api::UsersController < Api::ApiController

	def leave_current_cause
		response = LeaveCauseService.new(@current_user).perform
		if response.success?
			message = "Successfully left Cause"
			render_success_with_message(message)
		else
			render_error(:bad_request,response.errors)
		end
	end

	private
		
		def render_success_with_message(message)
			render status: :ok, json: {
		    	message: message
			}
		end
	
end
