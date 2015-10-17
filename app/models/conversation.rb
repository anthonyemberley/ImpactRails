class Conversation < ActiveRecord::Base
	belongs_to :user   #(index user_id)
	belongs_to :cause  #(index cause_id)
	has_many :messages 

	#validates :cause_name, :presence => true
	validates :cause_id, :presence => true
	validates :user_id, :presence => true


	scope :involving_user, -> (user_id) do
   		where("conversations.user_id =?",user_id)
  	end

  	scope :involving_cause, -> (cause_id) do
   		where("conversations.cause_id =?",cause_id)
  	end


    scope :between, -> (user_id,cause_id) do
    	where("(conversations.user_id = ? AND conversations.cause_id =?)", user_id,cause_id)
    end


end
