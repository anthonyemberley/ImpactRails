class Api::CategoriesController < Api::ApiController
	def get_all_categories
		render status: :ok , json: Category.all
	end

	def choose_categories
		response = ChooseCategoriesService.new(params,@current_user).perform
		if response.success?
			categories = response.result
			render status: :ok , json: categories.as_json
		else
			render_error(:bad_request, response.errors)
		end
	end

end
