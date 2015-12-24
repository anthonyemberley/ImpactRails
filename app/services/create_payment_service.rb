class CreatePaymentService < Aldous::Service
	PAYMENT_THRESHOLD = 1000
	
	def initialize(contribution,user)
		@contribution = contribution
		@user = user
		@cause = Cause.find_by(id:@user.current_cause_id)
	end

	def perform
		is_first_payment = @user.current_payment_id.nil?
		if is_first_payment
			puts "first payment!!!"
			new_payment = Payment.new
			new_payment.amount = @contribution.amount
			new_payment.user_id = @user.id
			new_payment.cause_id = @user.current_cause_id
			new_payment.cause_name = @cause.name
			if new_payment.save
				@contribution.update_attribute(:payment_id, new_payment.id)
				link_user_to_new_payment(new_payment)
				update_cause
				Result::Success.new(result: new_payment)
			else
				Result::Failure.new(errors: new_payment.errors)
			end
		else
			puts "OLD PAYMENT!!!"
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
				puts payment.amount.to_s+ " is below threshold!"
				puts "HERE IT IS PAYMENT!!!"
				puts payment.to_s
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