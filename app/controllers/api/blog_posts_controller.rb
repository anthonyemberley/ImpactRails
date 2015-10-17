class Api::BlogPostsController < Api::ApiController
	BLOG_POST_RESPONSE_KEY = "blog_post"

	def create
		response = BlogPostCreateService.new(create_params).perform

		if response.success?
				@blog_post = response.result
				render_create_blog_post(@blog_post)
		else
			render_error(:bad_request, "response.errors")
		end

	end


	def index
		@all_blogs = BlogPost.all
		render_list_of_blog_posts(@all_blogs)
	end

	def index_cause
		@cause_blog_posts = BlogPost.involving_cause(params[:cause_id])
		render_list_of_blog_posts(@cause_blog_posts)
	end



	private
		'''PARAMS'''
		def create_params
			params.require(BLOG_POST_RESPONSE_KEY).permit(:title, :blog_body, :image_url, :cause_id)
		end

		def index_cause_params
			params.require(BLOG_POST_RESPONSE_KEY, :cause_id)
		end

		'''RENDER'''
		def render_create_blog_post(blog)
			render status: :ok, json: blog.as_json
		end

		def render_list_of_blog_posts(blogs)
	    	render status: :ok , json: blogs.as_json
	    end

end
