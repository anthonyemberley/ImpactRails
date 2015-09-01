class CreateCauseService < Aldous::Service
	def initialize(cause_params)
		@cause_params = cause_params
	end

	def perform
		new_cause = Cause.new(@cause_params)
		if new_cause.save
			Result::Success.new(result: new_cause)
		else
			Result::Failure.new(errors: new_cause.errors)
		end
	end
end