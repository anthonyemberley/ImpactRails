class Api::StripeCardsController < Api::ApiController
	def get_credit_cards
		response = GetStripeCardsService.new(@current_user).perform
		if response.success? 
			credit_cards = response.result
			render status: :ok , json: credit_cards.as_json
		else
			render_error(:unauthorized, response.errors)
		end
	end

	def add_card
		response = AddStripeCardCustomerService.new(@current_user,params[:contribution][:stripe_generated_token]).perform
		if response.success?
			render status: :ok , json: response.as_json
		else
			render_error(:unauthorized, response.errors)
		end	
	end


	def delete_card
		puts "begin method"
		stripe_card_id = params[:card][:stripe_card_id]
		puts "we here"
		response = DeleteStripeCardService.new(@current_user,stripe_card_id).perform
		if response.succes?
			render status: :ok , json: response.result.as_json
		else
			render_error(:unauthorized, response.errors)
		end
	end
end
