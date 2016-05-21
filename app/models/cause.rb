class Cause < ActiveRecord::Base
	mount_uploader :profile_image_url, ImageUploader

	has_many :users, :through => :user_cause_relationships
	has_many :user_cause_relationships
	has_many :contributions
	has_many :payments
	has_many :blog_posts

	validates :name, :uniqueness => true, :presence => true
	#TODO make sure cause is one of the finite number of categories we have
	validates :category, :presence => true
	validates :description, :presence => true
	validates :goal, :presence => true
	after_initialize :set_default_values

    def set_default_values
      self.current_total  ||= 0
      self.number_of_contributors ||= 0
    end

    def fb_sorted_users
    	self.users.sort_by {|user| [user.facebook_id ? 0 : 1,user.facebook_id || 0]}	#sort users putting those with fb first
    end	
end
