class Contribution < ActiveRecord::Base
	belongs_to :user
	validates_numericality_of :amount, :greater_than_or_equal_to => 50
	validates :user_id, :presence => true
	validates :user_name, :presence => true
	validates :stripe_transaction_id, :presence => true
end
