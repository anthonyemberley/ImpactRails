class User < ActiveRecord::Base

	has_many :causes, :through => :user_cause_relationships
	has_many :user_cause_relationships
	has_many :categories, :through => :user_categories
	has_many :user_categories
	has_many :contributions
	has_many :conversations
	has_many :messages

	EMAIL_REGEX = /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
	validates :email, uniqueness: true, :format => EMAIL_REGEX, if: 'email.present?'
	validates :name, :presence => true
	validates :password, :presence => true, length: { minimum: 6 }, :unless => :facebook_id?
	attr_accessor :password

	before_save :encrypt_password, :ensure_authentication_token
	after_save :clear_password

	def categories
		return Category.where(id: self.user_categories.map{ |o| o.category_id }) 
	end

  	'''JSON RESPONSE '''
    def as_json(options={})
		options[:except] = [:encrypted_password, :salt, :encrypted_plaid_token, :stripe_customer_id]
		super
	end

	private
		''' Password Encryption '''
		def encrypt_password
		  if password.present?
		    self.salt = BCrypt::Engine.generate_salt
		    self.encrypted_password= BCrypt::Engine.hash_secret(password, salt)
		  end
		end

		def clear_password
		  self.password = nil
		end

		'''Authentication Token'''
		def ensure_authentication_token
		    if authentication_token.blank?
		      self.authentication_token = generate_authentication_token
		    end
		end

	    def generate_authentication_token
	    	loop do
	      		token = generate_secure_token_string
	      		break token unless User.where(authentication_token: token).first
	    	end
	    end

	    def generate_secure_token_string
	    	SecureRandom.urlsafe_base64(25).tr('lIO0', 'sxyz')
	  	end

	  	def reset_authentication_token!
	    	self.authentication_token = generate_authentication_token
	  	end
end
