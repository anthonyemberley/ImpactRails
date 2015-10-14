class BlogPostCreateService < Aldous::Service
	def initialize(create_params)
		@create_params = create_params
	end

	def perform
		new_post = BlogPost.new(@create_params)
		new_post.cause_id = @create_params[:cause_id] 
		if new_post.save
			Result::Success.new(result: new_post)
		else
			Result::Failure.new(errors: new_post.errors)
		end
	end

end