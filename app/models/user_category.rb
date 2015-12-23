class UserCategory < ActiveRecord::Base
	belongs_to :user
	belongs_to :category
	validates :user_id, :uniqueness => {:scope => :category_id}
end
