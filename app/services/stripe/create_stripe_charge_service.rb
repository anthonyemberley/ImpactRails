class CreateStripeChargeService < Aldous::Service
	require "stripe"
	Stripe.api_key = Rails.application.secrets.stripe_api_key

	def initialize(user, payment)
		@payment = payment
		@user = user
		@stripe_customer_id = @user.stripe_customer_id
	end

	def perform
		if @payment.amount <= 50
			Result::Failure.new(errors: "Amount contributed needs to be at least 50 cents")
		end
		begin 
			charge = Stripe::Charge.create(
  				:amount => @payment.amount,
  				:currency => "usd",
  				:customer => @stripe_customer_id,
  				:description => "Charged "+@amount.to_s+"for "+@user.id.to_s
			)
			stripe_charge = StripeCharge.create(
				:amount => charge.amount,
				:user_id => @user.id,
				:user_name => @user.name,
				:stripe_id => @stripe_customer_id,
				:stripe_transaction_id => charge.id,
				:payment_id => @payment.id
			)
			@user.update_attribute(:current_payment_id, nil)
			Result::Success.new(result: stripe_charge)
		rescue Exception => errors
			 Result::Failure.new(errors: errors.message)
		end
	end

end