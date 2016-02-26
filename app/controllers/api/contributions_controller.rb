class Api::ContributionsController < Api::ApiController
	CONTRIBUTIONS_USER_KEY = "contribution"
	PAYMENT_THRESHOLD = 1000

	def create_customer
		response = CreateStripeCustomerService.new(@current_user,params[:contribution][:stripe_generated_token]).perform
		if response.success?
			@current_user.update_attribute(:stripe_customer_id,response.result[:id])
			render status: :ok , json: response.as_json
		else
			render_error(:unauthorized, response.errors)
		end
	end

	def flat_donation

		# '''Check if user has current active payment, create one if not'''
		# no_current_payment = @current_user.current_payment_id.nil?
		# if no_current_payment
		# 	payment_response = CreatePaymentService.new(@current_user).perform
		# 	if payment_response.failure?
		# 		render_error(:bad_request,payment_response.errors)
		# 	end
		# end

		# '''Save Contribution '''
		# amount = params[:contribution][:amount]#@current_user.pending_contribution_amount
		# causeID = params[:contribution][:cause_id]

		# if !can_make_flat_donation?(amount)
		# 	return
		# end

		# '''Deleted updating relationship cause we dont need one?'''
		# if causeID == @current_user.current_cause_id
		# 	contribution_response = ContributionService.new(amount,@current_user).perform #STUB!
		# 	if contribution_response.failure? 
		# 		render_error(:bad_request,contribution_response.errors)
		# 		return
		# 	end
		# 	puts "SAVE CONTRIBUTION SUCCESSFUL"
		# 	contribution = contribution_response.result

		# 	'''Update User and Cause Relationship (amount contributed to cause) '''
		# 	user_cause_response = UpdateUserCauseService.new(@current_user,contribution.amount).perform #STUB!
		# 	if user_cause_response.failure?
		# 		render_error(:bad_request,user_cause_response.errors)
		# 		return
		# 	end
			
		# else
		# 	flat_donation_response = FlatDonationService.new(amount,@current_user, causeID).perform #STUB!
		# 	if flat_donation_response.failure? 
		# 		render_error(:bad_request,flat_donation_response.errors)
		# 		return
		# 	end
		# 	puts "SAVE CONTRIBUTION SUCCESSFUL"
		# 	contribution = flat_donation_response.result

		# end


		# '''Update User and its active payment '''
		# user_payment_response = UpdateUserPaymentService.new(@current_user,contribution).perform #STUB!
		# if user_payment_response.failure?
		# 	render_error(:bad_request,user_payment_response.errors)
		# 	return
		# end

		# '''Check if payment is above threshold, if it is then we create a stripe charge '''
		# payment = user_payment_response.result
		# if payment.amount > PAYMENT_THRESHOLD
		# 	charge_response = CreateStripeChargeService.new(@current_user,payment).perform
		# 	if charge_response.failure?
		# 		render_error(:bad_request,charge_response.errors)
		# 		return
		# 	end
		# 	render status: :ok , json: charge_response.result.as_json
		# 	return
		# end
		# render status: :ok, json: contribution.as_json

	end


	def pay
		'''Check if user has current active payment, create one if not'''
		no_current_payment = @current_user.current_payment_id.nil?
		if no_current_payment
			payment_response = CreatePaymentService.new(@current_user).perform
			if payment_response.failure?
				render_error(:bad_request,payment_response.errors)
			end
		end

		'''Save Contribution '''
		amount = params[:contribution][:amount]#@current_user.pending_contribution_amount
		if !can_make_payment?(amount)
			return
		end
		contribution_response = ContributionService.new(amount,@current_user).perform #STUB!
		if contribution_response.failure? 
			render_error(:bad_request,contribution_response.errors)
			return
		end
		puts "SAVE CONTRIBUTION SUCCESSFUL"
		contribution = contribution_response.result

		'''Update User and Cause Relationship (amount contributed to cause) '''
		user_cause_response = UpdateUserCauseService.new(@current_user,contribution.amount).perform #STUB!
		if user_cause_response.failure?
			render_error(:bad_request,user_cause_response.errors)
			return
		end

		'''Update User and its active payment '''
		user_payment_response = UpdateUserPaymentService.new(@current_user,contribution).perform #STUB!
		if user_payment_response.failure?
			render_error(:bad_request,user_payment_response.errors)
			return
		end

		'''Check if payment is above threshold, if it is then we create a stripe charge '''
		payment = user_payment_response.result
		if payment.amount > PAYMENT_THRESHOLD
			charge_response = CreateStripeChargeService.new(@current_user,payment).perform
			if charge_response.failure?
				render_error(:bad_request,charge_response.errors)
				return
			end
			render status: :ok , json: charge_response.result.as_json
			return
		end
		render status: :ok, json: contribution.as_json
	end

	def can_make_payment?(amount)
		if amount > @current_user.pending_contribution_amount
			render_error(:bad_request,"You cannot contribute more than the amount you've saved")
			return false
		end
		if @current_user.stripe_customer_id.blank?
			render_error(:bad_request,"You cannot contribute until you have provided your credit card information")
			return false
		end
		if @current_user.plaid_token.blank?
			render_error(:bad_request,"You cannot contribute until you have provided your credit card information")
			return false
		end
		if @current_user.current_cause_id.nil?
			render_error(:bad_request,"You cannot contribute until you have joined this cause")
			return false
		end

		return true

	end

	def can_make_flat_donation(amount)
		if @current_user.stripe_customer_id.blank?
			render_error(:bad_request,"You cannot contribute until you have provided your credit card information")
			return false
		end
		if @current_user.plaid_token.blank?
			render_error(:bad_request,"You cannot contribute until you have provided your credit card information")
			return false
		end
		if @current_user.current_cause_id.nil?
			render_error(:bad_request,"You cannot contribute until you have joined this cause")
			return false
		end

		return true


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
end
