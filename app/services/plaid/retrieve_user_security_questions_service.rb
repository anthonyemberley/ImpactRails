class RetrieveUserSecurityQuestionsService < Aldous::Service
	def initialize(answer_params)
		@access_token = answer_params[:access_token]
		@answer = answer_params[:answer]
	end

	def perform
		uri = URI.parse("https://tartan.plaid.com/connect/step")
        payload = {"secret" => Rails.application.secrets.plaid_secret , 
        			"client_id"=> Rails.application.secrets.plaid_client_id, 
        			"access_token" => @access_token, 
        			"mfa" => @answer
        		}
        req = Net::HTTP::Patch.new(uri.path)
        req.set_form_data(payload)
        req.content_type = 'application/x-www-form-urlencoded'
        res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
        body = JSON.parse(res.body)
        if res.code == "200" || res.code == "201"
        	Result::Success.new(result: body)
        else
        	Result::Failure.new(errors: "Invalid MFA Answer")
        end
end

end