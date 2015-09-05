class CreateStripeCustomerService < Aldous::Service
	require "stripe"
	Stripe.api_key = Rails.application.secrets.stripe_api_key

	def initialize(user,stripe_generated_token)
		@user = user
		@stripe_generated_token = stripe_generated_token
	end

	def perform
		begin 
			result = Stripe::Customer.create(
  				:description => "Created Stripe Customer for "+@user.id.to_s,
  				:source => @stripe_generated_token
			)	
			 Result::Success.new(result: result)
		rescue Exception => errors
			 Result::Failure.new(errors: errors.message)
		end
	end

end