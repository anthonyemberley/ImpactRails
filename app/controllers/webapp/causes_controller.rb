class Webapp::CausesController < Webapp::WebappController
	CAUSE_RESPONSE_KEY = "cause"
	def create
		response = CreateCauseService.new(create_cause_params,@organization).perform
		if response.success?
			cause = response.result
			render_default_cause_response(cause)
		else
			render_error(:unauthorized,response.errors)
		end
	end

	def get
		cause = Cause.find_by(id:params[:id])
		if cause.present?
			render_default_cause_response(cause)
		else
			render_error(:bad_request,"Cannot find cause with id "+ params[:id])
		end
	end

	def update_cause_photo_url

	end

	private
	    '''PARAMS '''
	    def create_cause_params 
	     	params.require(CAUSE_RESPONSE_KEY).permit(:name,:description, :category, :goal)
	    end

		def causes_from_category_params
			params.require(:category)
		end

	    '''RENDER'''
	    def render_default_cause_response(cause)
			render status: :ok , json: cause.as_json
			
		end

		def render_list_of_causes(causes)
	    	render status: :ok , json: causes.as_json
	    end
end
