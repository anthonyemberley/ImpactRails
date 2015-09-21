class StripePayment < ActiveRecord::Base
	belongs_to :user
	belongs_to :cause
	has_many :contributions
end
