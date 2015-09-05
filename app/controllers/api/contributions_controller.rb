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
		amount = params[:contribution][:amount]
		stripe_response = ChargeStripeCustomerService.new(amount,@current_user).perform
		if stripe_response.success?
			save_contribution(stripe_response.result)
		else
			render_error(:unauthorized, stripe_response.errors)
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
end
