class StripeCharge < ActiveRecord::Base
	has_one :payment
end
