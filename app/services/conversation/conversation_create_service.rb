class ConversationCreateService < Aldous::Service
	def initialize(create_params)
		@create_params = create_params
	end

	def perform
		new_conversation = Conversation.new(@create_params)
		new_conversation.user_id = @create_params[:user_id]
		new_conversation.cause_id = @create_params[:cause_id] 
		if new_conversation.save
			Result::Success.new(result: new_conversation)
		else
			Result::Failure.new(errors: new_conversation.errors)
		end

	end

end