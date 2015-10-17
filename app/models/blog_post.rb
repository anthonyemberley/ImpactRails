class BlogPost < ActiveRecord::Base
	belongs_to :cause

	validates :cause_id, :presence => true
	validates :title, :presence => true
	validates :blog_body, :presence => true
	validates :image_url, :presence => true
	

	scope :involving_cause, -> (cause_id) do
   		where("blog_posts.cause_id =?",cause_id)
  	end
end
