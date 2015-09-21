class Message < ActiveRecord::Base
	belongs_to :conversation #(index cause_id)
	belongs_to :user 
	belongs_to :cause
	#belongs_to :messageable polymorphic: true (for user or cause)
	#TODO determine if a message is from a user or from a cause - belongs to above 

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
