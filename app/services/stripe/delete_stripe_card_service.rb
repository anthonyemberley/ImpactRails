class DeleteStripeCardService < Aldous::Service
	require "stripe"
	Stripe.api_key = Rails.application.secrets.stripe_api_key
	def initialize(user,stripe_card_id)
		@user = user
		@stripe_card_id = stripe_card_id
	end

	def perform
		puts "here"
		#if user.stripe_card_id == @stripe_card_id
		#	user.update_attribute(:stripe_card_id,nil)
		#end
		puts "here2"
		begin 
			puts "here3"
			customer = Stripe::Customer.retrieve(@user.stripe_customer_id)
			puts "here4"
			response = customer.sources.retrieve(@stripe_card_id).delete
			Result::Success.new(result: response)
		rescue Exception => errors
			Result::Failure.new(errors: errors.message)
		end
	end

end