class Api::ConversationsController < Api::ApiController
	CONVERSATION_RESPONSE_KEY = "conversation"

	#TODO create a conversation that only shows the messages from the cause
	#TODO come up with a way to only show causes the messages that have been responded to

	#user starts conversation with its current cause
	def create
		#TODO check if there exists a conversation between the two
		if Conversation.between(params[:user_id],params[:cause_id]).present?
      		response = Conversation.between(params[:user_id],params[:cause_id]).first
      	else
			response = ConversationCreateService.new(create_params).perform
		end

		if response.success?
				@conversation = response.result
				render_create_convo(@conversation)
		else
			render_error(:bad_request, "response.errors")
		end
	end


	#get all conversations
	def index
		@all_convos = Conversation.all
		render_list_of_convos(@all_convos)
	end

	#get all conversations for a given cause
	def index_cause
		@cause_convos = Conversation.involving_cause(params[:cause_id])
		render_list_of_convos(@cause_convos)
	end

	#get all conversations for a given user (past included)
	def index_user
		@user_convos = Conversation.involving_user(params[:user_id])
		render_list_of_convos(@user_convos)
	end



	private
		'''PARAMS'''
		def create_params
			params.require(CONVERSATION_RESPONSE_KEY).permit(:cause_name, :user_id, :cause_id)
		end

		

		def index_cause_params
			params.require(CONVERSATION_RESPONSE_KEY, :cause_id).permit(:cause_name)
		end

		def index_user_params
			params.require(CONVERSATION_RESPONSE_KEY, :user_id)
		end

		'''RENDER'''
		def render_create_convo(convo)
			render status: :ok, json: convo.as_json
		end

		def render_list_of_convos(convos)
	    	render status: :ok , json: convos.as_json
	    end
	



end
