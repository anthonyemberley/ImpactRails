class Category < FrozenRecord::Base
	self.base_path = Rails.root.join('config', 'data')
	#has_many :users, :through => :user_categories
end
