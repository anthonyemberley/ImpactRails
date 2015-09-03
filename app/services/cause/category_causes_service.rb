class CategoryCausesService < Aldous::Service
	def initialize(category)
		@category = category
	end
	def perform
		causes = Cause.all
		selected_causes = causes.select{|cause| cause.category == @category}
		if selected_causes.length!=0
			Result::Success.new(result: selected_causes)
		else
			Result::Failure.new(errors: "No causes for category")
		end
	end
end