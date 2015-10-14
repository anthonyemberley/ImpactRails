class CreateBlogCommentService < Aldous::Service
	def initialize(create_params)
		@create_params = create_params
	end

	def perform
		new_comment = BlogComment.new(@create_params)
		new_comment.blog_post_id = @create_params[:blog_post_id] 
		new_comment.user_id = @create_params[:user_id]
		if new_comment.save
			Result::Success.new(result: new_comment)
		else
			Result::Failure.new(errors: new_comment.errors)
		end
	end

end