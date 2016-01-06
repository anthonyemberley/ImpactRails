class Contribution < ActiveRecord::Base
	belongs_to :user
	validates_numericality_of :amount, :greater_than => 0 
	validates :user_id, :presence => true
	validates :user_name, :presence => true
	belongs_to :cause
	belongs_to :payment
end
