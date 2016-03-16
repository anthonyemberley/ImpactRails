class DeleteStripeCardService < Aldous::Service
	require "stripe"
	Stripe.api_key = Rails.application.secrets.stripe_api_key
	def initialize(user,stripe_card_id)
		@user = user
		@stripe_card_id = stripe_card_id
	end

	def perform
		begin 
			card = Stripe::Customer.retrieve(@user.stripe_customer_id).sources.data
			puts "here1"
			card_array = Array(card)
			puts "here2"
			if card_array.count == 1
				puts "here 3"
				@current_user.update_attribute(:has_credit_card,false)
			end
			puts "here4"
			customer = Stripe::Customer.retrieve(@user.stripe_customer_id)
			response = customer.sources.retrieve(@stripe_card_id).delete
			Result::Success.new(result: response)
		rescue Exception => errors
			Result::Failure.new(errors: errors.message)
		end
	end

end