class GetStripeCardsService < Aldous::Service
	require "stripe"
	Stripe.api_key = Rails.application.secrets.stripe_api_key
	def initialize(user)
		@user = user
	end

	def perform
		begin 
			card = Stripe::Customer.retrieve(@user.stripe_customer_id).sources.data
			Result::Success.new(result: card)
		rescue Exception => errors
			Result::Failure.new(errors: errors.message)
		end
	end

end