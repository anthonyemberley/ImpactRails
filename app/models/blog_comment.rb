class BlogComment < ActiveRecord::Base
	belongs_to :user
	belongs_to :blog_post

	validates: :user_id, :presence => true
	validates: :cause_id, :presence => true
	validates: :message, :presence => true


	scope :with_blog_post, -> (blog_post_id) do
   		where("blog_posts.id =?",blog_post_id)
  	end

end
