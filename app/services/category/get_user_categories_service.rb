class GetUserCategoriesService < Aldous::Service
	def initialize(current_user)
		@current_user = current_user
	end

	def perform
		user_categories = UserCategory.where(user_id: @current_user.id)
		category_ids = Array.new
		user_categories.each do |user_category|
			category_ids.push(user_category.category_id)
		end
		categories = Category.where(id: category_ids)
		Result::Success.new(result:categories)
	end

end