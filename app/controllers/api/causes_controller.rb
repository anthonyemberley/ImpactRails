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
		render_cause_index_response(@causes)
	end

	def get_causes_from_category
		response = CategoryCausesService.new(causes_from_category_params).perform
		if response.success?
			causes = response.result
			render_default_cause_response(causes)
		else
			render_error(404,response.errors)
		end
	end

	private
	    '''PARAMS '''
	    def create_cause_params 
	     	params.require(CAUSE_RESPONSE_KEY).permit(:name,:description, :category)
	    end


		def causes_from_category_params
			params.require(:category)
		end

	    '''RENDER'''
	    def render_default_cause_response(cause)
			render status: :ok , json: cause.as_json
			
		end

		def render_cause_index_response(causes)
	    	render status: :ok , json: causes.as_json
		end

	    def render_error(status,errors) 
	    	render status: status, json: {
		    	errors: errors
			}
	    end


end
