class CreateMessageService < Aldous::Service
	def initialize(message_params)
		@message_params = message_params
	end

	def perform
		new_message = Message.new(@message_params)
		if new_message.save
			Result::Success.new(result: new_message)
		else
			Result::Failure.new(errors: new_message.errors)
		end
	end

end
