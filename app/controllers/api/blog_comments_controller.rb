class Api::BlogCommentsController < Api::ApiController
	COMMENTS_RESPONSE_KEY = 'blog_comments'

	def create
		response = CreateBlogCommentService.new(create_params).perform
		if response.success?
			comment = response.result
			render_comment_success(comment)
		else
			render_error(:bad_request, response.errors)
		end
	end


	def get
		@blog_post_messages = Message.with_conversation(params[:blog_post_id])
		render_list_of_messages(@blog_post_messages)
	end



	private

		'''PARAMS'''
		def create_params
				params.require(COMMENTS_RESPONSE_KEY).permit(:user_id, :blog_post_id, :title, :message)
		end

		def get_comments_params
				params.require(COMMENTS_RESPONSE_KEY, :blog_post_id).permit(:conversation_id,:cause_id)
		end

		'''RENDER'''
		def render_comment_success(comment)
			render status: :ok, json: comment.as_json

		end

		def render_list_of_comments(comments)
			render status: :ok, json: comments.as_json
		end


end
