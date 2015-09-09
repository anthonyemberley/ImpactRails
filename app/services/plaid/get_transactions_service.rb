class GetTransactionsService < Aldous::Service
	def initialize(plaid_access_token, gte_date)
		@plaid_access_token = plaid_access_token
                @gte_date = gte_date
	end

	def perform
	        uri = URI.parse("https://tartan.plaid.com/connect/get")
                options_string = '{"gte":"' + @gte_date.to_s + '"}'
                payload = {"secret" => Rails.application.secrets.plaid_secret , 
                			"client_id"=> Rails.application.secrets.plaid_client_id, 
                			"access_token" => @plaid_access_token,
                			"options" => options_string
                		}
                req = Net::HTTP::Post.new(uri.path)
                req.set_form_data(payload)
                req.content_type = 'application/x-www-form-urlencoded'
                res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
                body = JSON.parse(res.body)
                transactions = body['transactions']
                if transactions.present?
                	Result::Success.new(result: transactions)
                else
                	Result::Failure.new(errors:"No transactions were found")
                end
	end

end