class CreateOrganizationService < Aldous::Service

	def initialize(organization_params)
		@organization_params = organization_params
	end

	def perform
		new_organization = Organization.new(@organization_params)
		if new_organization.save
			Result::Success.new(result: new_organization)
		else
			Result::Failure.new(errors: new_organization.errors)
		end
	end

end