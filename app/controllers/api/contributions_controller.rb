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
		amount = @current_user.pending_contribution_amount
		contribution_response = SaveContributionService.new(amount,@current_user).perform
		if contribution_response.success?
			update_payment_total(contribution_response.result)
		else 
			render_error(:unauthorized, response.errors)
		end
	end

	def get_user_contributions
		contributions = @current_user.contributions.paginate(:page => params[:page],:per_page => 30).order('created_at DESC')
		render status: :ok , json: contributions.as_json
	end

	def get_cause_contributions
		cause = Cause.find_by(id: params[:id])
		contributions = cause.contributions.paginate(:page => params[:page],:per_page => 30).order('created_at DESC')
		render status: :ok , json: contributions.as_json
	end

	private

		def update_payment_total(contribution)
			response = CreatePaymentService.new(contribution,@current_user).perform
			if response.success?
				render status: :ok , json: response.result.as_json
			else
				render_error(:unauthorized, response.errors)
			end
		end
end
