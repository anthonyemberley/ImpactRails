class Cause < ActiveRecord::Base
	has_many :users, :through => :user_cause_relationships
	has_many :user_cause_relationships
	has_many :contributions
	has_many :payments

	validates :name, :uniqueness => true, :presence => true
	#TODO make sure cause is one of the finite number of categories we have
	validates :category, :presence => true
	validates :description, :presence => true
	validates :goal, :presence => true
	after_initialize :set_default_values

    def set_default_values
      self.current_total  ||= 0
      self.number_of_contributors ||= 0
    end
end
