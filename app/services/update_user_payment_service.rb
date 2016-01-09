class UpdateUserPaymentService < Aldous::Service
	PAYMENT_THRESHOLD = 1000
	
	def initialize(user, contribution)
		@contribution = contribution
		@user = user
	end

	def perform
		payment = Payment.find_by(id:@user.current_payment_id)
		payment.increment!(:amount, @contribution.amount)
		puts "user id: "+@user.id.to_s+ " is making a payment"
		Result::Success.new(result: payment)
	end
end