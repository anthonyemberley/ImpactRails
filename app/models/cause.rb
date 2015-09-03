class Cause < ActiveRecord::Base
	has_many :users, :through => :user_cause_relationships
	has_many :user_cause_relationships

	validates :name, :uniqueness => true, :presence => true
	#TODO make sure cause is one of the finite number of categories we have
	validates :category, :presence => true
	validates :description, :presence => true
end
