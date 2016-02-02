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

	def delete_card
		stripe_card_id = params[:card][:stripe_card_id]
		response = DeleteStripeCardService.new(@current_user,stripe_card_id).perform
		if response.succes?
			render status: :ok , json: response.result.as_json
		else
			render_error(:unauthorized, response.errors)
		end
	end
end
