class Message < ActiveRecord::Base
	belongs_to :cause #(index cause_id)
	has_many :users, :through user_message_relationship

	validates :title, :presence => true
	validates :image_url #, :presence => true
	validates :conversation_id, :presence => true
	validates :message_body, :presence => true
end
