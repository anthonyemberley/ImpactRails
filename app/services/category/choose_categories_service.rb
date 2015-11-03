class ChooseCategoriesService < Aldous::Service

	def initialize(category_params,current_user)
		@category_ids = category_params[:categories][:category_ids]
		@current_user = current_user
	end

	def perform
		new_relationships = Array.new
		@category_ids.each do |category_id|
			relationship = UserCategory.new
			relationship.user_id = @current_user.id
			relationship.category_id = category_id
			new_relationships.push(relationship)
		end
		if @current_user.user_categories.replace(new_relationships)
			categories = Category.where(id: @category_ids)
			Result::Success.new(result:categories)
		else
			Result::Failure.new(errors: "Unable to Update Your Category Preferences")
		end
	end

end