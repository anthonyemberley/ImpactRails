class CreatePaymentService < Aldous::Service
	
	def initialize(user)
		@user = user
	end

	def perform
		puts "user id: "+@user.id.to_s+ " is making a new payment"
		new_payment = Payment.new(
						:amount => 0,
						:user_id => @user.id,
						:user_name => @user.name,
						:user_email => @user.email
			)
		if new_payment.save
			@user.update_attribute(:current_payment_id, new_payment.id)
			puts "user id: "+@user.id.to_s+ " made a new payment and it save successfully"
			Result::Success.new(result: new_payment)
		else
			Result::Failure.new(errors: new_payment.errors)
		end
	end

end