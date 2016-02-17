class AddStripeCardCustomerService < Aldous::Service
	require "stripe"
	Stripe.api_key = Rails.application.secrets.stripe_api_key

	def initialize(user, stripe_generated_token)
		@user = user
		@stripe_customer_id = user.stripe_customer_id
		@stripe_generated_token = stripe_generated_token

	end

	def perform
		begin 
			customer = Stripe::Customer.retrieve(@stripe_customer_id)
			result = customer.sources.create(
				:source => stripe_generated_token
				:description => "Added New Card For "+@user.id.to_s,
				)
			 Result::Success.new(result: result)
		rescue Exception => errors
			 Result::Failure.new(errors: errors.message)
		end
	end

end