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
		puts @cause_params
		state = if @cause_params[:state].nil? then @organization.state else @cause_params[:state] end
		city = if @cause_params[:city].nil? then @organization.city else @cause_params[:city] end
		country = if @cause_params[:country].nil? then @organization.country else @cause_params[:country] end
		new_cause.state = state
		new_cause.city = city
		new_cause.country = country
		coordinates = Geokit::Geocoders::MultiGeocoder.geocode(city+","+state)
		if !coordinates.nil?
			new_cause.latitude = coordinates.lat
			new_cause.longitude = coordinates.lng
		end
		if new_cause.save
			Result::Success.new(result: new_cause)
		else
			Result::Failure.new(errors: new_cause.errors)
		end
	end
end