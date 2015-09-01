class Api::CausesController < ApplicationController

	def create
		temp_json_string = "{"cause":{"name": "red cross", "category": "homeless", "description": "ex.description"}"
		parsed_json_hash = JSON.parse temp_json_string

		#don't really get where this goes after here
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
	     	params.permit(:name,:description, :category)
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
