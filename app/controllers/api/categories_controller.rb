class Api::CategoriesController < Api::ApiController
	def get_all_categories
		render status: :ok , json: Category.all
	end

end
