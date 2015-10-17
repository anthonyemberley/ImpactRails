module Webapp
	class WebappController < ApplicationController
		respond_to :json
		before_filter :authenticate_organization_from_token

		def authenticate_organization_from_token
		    @organization_auth_token = request.headers["AUTHENTICATION-TOKEN"].presence	#this will require tokens on headers
		    response = WebAppAuthenticateTokenService.new(@organization_auth_token).perform
		    if response.success?
		    	@organization = response.result
		    else 
		    	render status: :unauthorized, json: {
			    	errors: "Invalid Token You do not have access to this api"
				}
		    end 
		end

		'''Rendering'''
		def render_success_with_message(status,message)
			render status: status, json: {
		    	message: message
			}
		end

		def render_error(status,errors) 
	    	render status: status, json: {
		    	errors: errors
			}
	    end
	end
end