class CreatePaymentService < Aldous::Service
	PAYMENT_THRESHOLD = 1000
	
	def initialize(user)
		@user = user
	end

	def perform
		puts "user id: "+@user.id.to_s+ " is making a new payment"
		new_payment = Payment.new(
						:amount => 0,
						:user_id => @user.id,
						:user_name => @user.name
			)
			if new_payment.save
				@contribution.update_attribute(:payment_id, new_payment.id)
				link_user_to_new_payment(new_payment)
				update_cause
				puts "user id: "+@user.id.to_s+ " made a new payment and it save successfully"
				Result::Success.new(result: new_payment)
			else
				Result::Failure.new(errors: new_payment.errors)
			end
		else
			puts "user id: "+@user.id.to_s+ " is making an old payment"
			payment = Payment.find_by(id:@user.current_payment_id)
			payment.increment!(:amount, @contribution.amount)
			update_cause
			if payment.amount >= PAYMENT_THRESHOLD
				puts payment.amount.to_s+ " is above threshold!"
				stripe_response = ChargeStripeCustomerService.new(payment.amount,@user).perform
				if stripe_response.success?
					update_completed_payment(payment,stripe_response.result[:id])
					Result::Success.new(result: stripe_response.result)
				else
					Result::Failure.new(errors: stripe_response.errors)
				end
			else
				puts "user id: "+@user.id.to_s+ " made payment below thrsehold"
				puts payment.amount.to_s+ " is below threshold!"
				Result::Success.new(result: payment)
			end
		end
	end

	private

		def update_completed_payment(payment, stripe_transaction_id)
			payment.increment!(:amount, @contribution.amount)
			payment.update_attribute(:transaction_completed, true)
			payment.update_attribute(:stripe_transaction_id, stripe_transaction_id)
			@user.update_attribute(:current_payment_id, nil)
			@user.update_attribute(:last_contribution_date, DateTime.now)
			
		end

		def update_cause
			@cause.increment!(:current_total, @contribution.amount)
		end

		def link_user_to_new_payment(new_payment)
			@user.update_attribute(:last_contribution_date, DateTime.now)
			@user.update_attribute(:current_payment_id, new_payment.id)
		end

end