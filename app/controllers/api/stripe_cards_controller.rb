class Api::StripeCardsController < ApplicationController
	def get_credit_cards
		response = GetStripeCardsService.new(@current_user).perform
		if response.success? 
			credit_cards = response.result
			render status: :ok , json: credit_cards.as_json
		else
			render_error(:unauthorized, response.errors)
		end
	end
end
