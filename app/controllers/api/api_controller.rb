module Api
	class ApiController < ApplicationController
		respond_to :json
		before_filter :authenticate_user_from_token

		def authenticate_user_from_token
		    @user_auth_token = request.headers["AUTHENTICATION-TOKEN"].presence	#this will require tokens on headers
		    response = AuthenticateTokenService.new(@user_auth_token).perform
		    if response.success?
		    	@current_user = response.result
		    else 
		    	render status: :unauthorized, json: {
			    	errors: "Invalid Token You do not have access to this api"
				}
		    end 
		end


		''' Encrypt and Decrypt '''
		def encrypt(string)
			salt  = @current_user.salt
			key   = ActiveSupport::KeyGenerator.new(Rails.application.secrets.plaid_secret).generate_key(salt)
			crypt = ActiveSupport::MessageEncryptor.new(key) 
			encrypted_token = crypt.encrypt_and_sign(string)  
			return  encrypted_token
		end

		def decrypt(encrypted_string)
			puts 'DECRYPT!!!'
			if !encrypted_string.blank?
				salt  = @current_user.salt
				key   = ActiveSupport::KeyGenerator.new(Rails.application.secrets.plaid_secret).generate_key(salt)
				crypt = ActiveSupport::MessageEncryptor.new(key) 
				decrypted_token = crypt.decrypt_and_verify(encrypted_string) 
				return decrypted_token
			end
		end
		
		'''Rendering'''
		def render_success_with_message(status,message)
			render status: status, json: {
		    	message: message
			}
		end

		def render_error(status,errors) 
	    	render status: status, json: {
		    	errors: errors
			}
	    end
	end
end 
