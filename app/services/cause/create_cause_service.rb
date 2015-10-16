class CreateCauseService < Aldous::Service
	def initialize(cause_params, organization)
		@cause_params = cause_params
		@organization = organization
	end

	def perform
		new_cause = Cause.new(@cause_params)
		new_cause.organization_id = @organization.id
		new_cause.organization_name = @organization.organization_name
		new_cause.organization_logo_url = @organization.logo_url
		puts @organization.logo_url
		if new_cause.save
			Result::Success.new(result: new_cause)
		else
			Result::Failure.new(errors: new_cause.errors)
		end
	end
end