class Message < ActiveRecord::Base
	belongs_to :conversation #(index cause_id)
	belongs_to :user 
	belongs_to :cause
	
	validates :title, :presence => true
	#validates :image_url #, :presence => true
	validates :conversation_id, :presence => true
	validates :message_body, :presence => true
	validates :user_id, :presence => true
	validates :cause_id, :presence => true

	scope :with_conversation, -> (conversation_id) do
   		where("conversations.id =?",conversation_id)
  	end
	
end
