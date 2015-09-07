class CalculateContributionService < Aldous::Service
	def initialize(transactions)
		@transactions = transactions
	end

	def perform
		total = 0
		@transactions.each do |transaction|
			amount = transaction["amount"]
			if amount > 0
				total += calculate_change(amount)
			end
		end
		Result::Success.new(result: total)
	end

	private

	def calculate_change(amount)
		nearest_dollar = amount.ceil
		difference = nearest_dollar - amount
		return (difference * 100).round
	end



end