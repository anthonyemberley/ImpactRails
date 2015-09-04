class RetrievePlaidUserService < Aldous::Service
	def initialize(plaid_params)
		@username = plaid_params[:username] 
		@password = plaid_params[:password]
		@access_token = plaid_params[:access_token]
		@pin = plaid_params[:pin]
	end

	def perform
		uri = URI.parse("https://tartan.plaid.com/connect")
                payload = {"secret" => Rails.application.secrets.plaid_secret , 
                			"client_id"=> Rails.application.secrets.plaid_client_id, 
                			"access_token" => @access_token, 
                			"username" => @username, 
                			"password" => @password, 
                			"pin" => @pin}
                req = Net::HTTP::Patch.new(uri.path)
                req.set_form_data(payload)
                req.content_type = 'application/x-www-form-urlencoded'
                res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
                body = JSON.parse(res.body)
                if res.code == "200" || res.code == "201"
                        Result::Success.new(result: body)
                else
                        Result::Failure.new(errors: "Invalid Credentials")
                end
	end
end