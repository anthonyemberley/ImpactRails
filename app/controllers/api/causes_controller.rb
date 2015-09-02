class Api::CausesController < Api::ApiController
	CAUSE_RESPONSE_KEY = "cause"

	def create
		response = CreateCauseService.new(create_cause_params).perform
		if response.success?
			cause = response.result
			render_default_cause_response(cause)
		else
			render_error(:unauthorized,response.errors)
		end

	end

	def index
		@causes = Cause.all
	end


	private


	    '''PARAMS '''
	    def create_cause_params 
	     	params.require(CAUSE_RESPONSE_KEY).permit(:name,:description, :category)
	    end


	    '''RENDER'''
	    def render_default_cause_response(cause)
			render status: :ok, json: {
		    	message: "Successfully created a new cause named " + cause.name
			}
		end

	    def render_error(status,errors) 
	    	render status: status, json: {
		    	errors: errors
			}
	    end


end
