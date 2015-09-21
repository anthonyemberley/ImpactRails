class Api::MessagesController < Api::ApiController
	MESSAGE_RESPONSE_KEY = "message"
	MESSAGES_RESPONSE_KEY = "messages"

	#user creates message to 1 cause
	def create
		response = CreateMessageService.new(create_params).perform
		if response.success?
			message = response.result
			render_message_success(message)
		else
			render_error(:bad_request, response.errors)
		end
	end


	def get
		@conversation_messages = Message.with_conversation(params[:conversation_id])
		render_list_of_messages(@conversation_messages)
	end



	private

		'''PARAMS'''
		def create_params
				params.require(MESSAGE_RESPONSE_KEY).permit( :conversation_id, :user_id, :cause_id, :title, :message_body)
		end

		def get_messages_params
				params.require(MESSAGES_RESPONSE_KEY, :conversation_id).permit(:conversation_id,:cause_id)
		end

		'''RENDER'''
		def render_message_success(message)
			render status: :ok, json: message.as_json

		end

		def render_list_of_messages(messages)
			render status: :ok, json: convos.as_json
		end
		

end
