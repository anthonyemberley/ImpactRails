class Api::MessagesController < Api::ApiController
	MESSAGE_RESPONSE_KEY = "message"


	#user creates message to 1 cause
	def user_create

	end

	#cause creates message to 1 user or all "following" users
	def cause_create

	end

	#get all messages between a user and a cause - only indexing cause_id - consider also
	#user id
	def get_messages

	end



	private

		'''PARAMS'''
		def user_create_params
				params.require(MESSAGE_RESPONSE_KEY, :conversation_id)
		end

		def cause_create_params

		end

		def get_messages_params

		end

		'''RENDER'''
		def render_message_success

		end

		def render_message_fail

		end
		

end
