class Api::ContributionsController < Api::ApiController
	CONTRIBUTIONS_USER_KEY = "contribution"

	def add_card
		response = CreateStripeCustomerService.new(@current_user,params[:contribution][:stripe_generated_token]).perform
		if response.success?
			@current_user.update_attribute(:stripe_customer_id,response.result[:id])
			render status: :ok , json: response.as_json
		else
			render_error(:unauthorized, response.errors)
		end
	end

	def pay
		plaid_access_token = decrypt(@current_user.encrypted_plaid_token)
		gte_date = @current_user.last_contribution_date
		if gte_date.nil?
			gte_date = Time.now.getutc
		end
		response = GetTransactionsService.new(plaid_access_token, gte_date).perform
		if response.success?
			amount = CalculateContributionService.new(response.result).perform.result
			contribution_response = SaveContributionService.new(amount,@current_user).perform
			if contribution_response.success?
				update_payment_total(contribution_response.result)
			end
		else 
			render_error(:unauthorized, response.errors)
		end
	end

	def get_user_contributions
		contributions = @current_user.contributions
		render status: :ok , json: contributions.as_json
	end

	def get_cause_contributions
		cause = Cause.find_by(id: params[:id])
		contributions = cause.contributions
		render status: :ok , json: contributions.as_json
	end

	private

		def save_contribution(stripe_response)
			response = SaveContributionService.new(stripe_response,@current_user).perform
			if response.success?
				render status: :ok , json: response.result.as_json
			else
				render_error(:unauthorized, response.errors)
			end
		end
		#TODO: REFACTOR: CreatePaymentService, UpdatePaymentService
		def update_payment_total(contribution)
			if @current_user.current_payment_id.nil?
				payment = Payment.new
				payment.amount = contribution.amount
				payment.user_id = @current_user.id
				payment.cause_id = @current_user.current_cause_id
				payment.save
				contribution.update_attribute(:payment_id, payment.id)
				@current_user.update_attribute(:last_contribution_date, payment.created_at)
				@current_user.update_attribute(:current_payment_id, payment.id)
				render 
				render status: :ok , json: payment.as_json
			else
				payment = Payment.find_by(id:@current_user.current_payment_id)
				payment.increment!(:amount, contribution.amount)
				if payment.amount >= 1000
					payment.update_attribute(:transaction_completed, true)
					@current_user.update_attribute(:current_payment_id, nil)
					stripe_response = ChargeStripeCustomerService.new(payment.amount,@current_user).perform
					if stripe_response.success?
						payment.update_attribute(:stripe_transaction_id, stripe_response.result[:id])
						render status: :ok , json: stripe_response.as_json
					else
						render_error(:unauthorized, stripe_response.errors)
					end
				else
					render status: :ok , json: payment.as_json
				end
			end
		end
end
