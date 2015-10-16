class Webapp::OrganizationController < Webapp::WebappController
	ORGANIZATION_RESPONSE_KEY = "organization"
	skip_before_filter :authenticate_organization_from_token, :only => [:sign_up, :login]
	def sign_up
		response = CreateOrganizationService.new(create_organization_params).perform
		if response.success?
			@organization = response.result
			render_default_organization_response(@organization)
		else
			render_error(:unauthorized,response.errors)
		end
	end

	def login
		response = OrganizationLoginService.new(organization_login_params).perform
		if response.success?
			@organization = response.result
			render_default_organization_response(@organization)
		else
			render_error(:unauthorized,response.errors)
		end
	end

	def update_logo_url
		logo_url = params[:organization][:logo_url]
		if @organization.update_attribute(:logo_url,logo_url)
			render status: :ok , json: {:message => "Successfully Updated Logo", :logo_url =>logo_url}.as_json
		else
			render_error(500, @organization.errors)
		end
	end
	private
	    '''PARAMS '''
	    def create_organization_params 
	     	params.require(ORGANIZATION_RESPONSE_KEY).permit(:organization_name,:username, :nonprofit_id,:password)
	    end

	    def organization_login_params
	    	params.require(ORGANIZATION_RESPONSE_KEY).permit(:username,:password)
	    end

	    	    '''RENDER'''
	    def render_default_organization_response(organization)
	    	render status: :ok , json: organization.as_json
		end
end
