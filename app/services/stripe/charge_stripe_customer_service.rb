class ChargeStripeCustomerService < Aldous::Service
	require "stripe"
	Stripe.api_key = Rails.application.secrets.stripe_api_key

	def initialize(amount,user)
		@amount = amount
		@user = user
		@stripe_customer_id = @user.stripe_customer_id
	end

	def perform
		begin 
			result = Stripe::Charge.create(
  				:amount => @amount,
  				:currency => "usd",
  				:customer => @stripe_customer_id,
  				:description => "Charged "+@amount.to_s+"for "+@user.id.to_s
			)
			Result::Success.new(result: result)
		rescue Exception => errors
			 Result::Failure.new(errors: errors.message)
		end
	end

end