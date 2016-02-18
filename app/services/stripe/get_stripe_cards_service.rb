class GetStripeCardsService < Aldous::Service
	require "stripe"
	Stripe.api_key = Rails.application.secrets.stripe_api_key
	def initialize(user)
		@user = user
	end

	def perform
		puts "retrieving credit card information from with stripe_customer_id: "+@user.stripe_customer_id
		if @user.stripe_customer_id.blank?
			Result::Failure.new(errors: "You do not have a registered credit card")
			return
		end
		begin 
			card = Stripe::Customer.retrieve(@user.stripe_customer_id).sources.data
			puts "retrieved "+card.to_s
			Result::Success.new(result: card)
		rescue Exception => errors
			Result::Failure.new(errors: errors.message)
		end
	end

end