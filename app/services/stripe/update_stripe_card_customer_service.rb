class UpdateStripeCardCustomerService < Aldous::Service
	require "stripe"
	Stripe.api_key = Rails.application.secrets.stripe_api_key

	def initialize(user, card_id, exp_month, exp_year)
		@user = user
		@stripe_customer_id = user.stripe_customer_id
		@exp_month = exp_month
		@exp_year = exp_year
		@card_id = card_id

	end

	def perform
		begin 
			customer = Stripe::Customer.retrieve(@stripe_customer_id)
			card = customer.sources.retrieve(@card_id)
			card.exp_month = @exp_month
			card.exp_year = @exp_year
			result = card.save()
			 Result::Success.new(result: result)
		rescue Exception => errors
			 puts errors.message.to_s
			 Result::Failure.new(errors: errors.message)
		end
	end

end