class PasswordResetMailer < ApplicationMailer

	  default from: "impactappmailer@gmail.com"

	  def sample_email(email)
	  	@email = email
	    mail(to: @email, subject: 'Welcome to My Awesome Site')
	  end

	  def password_reset(user)
	  	@email = user.email

	  	new_password = (0...8).map { (65 + rand(26)).chr }.join

	  	@body = "You have reset your password.  If this was not you, please email info@impactapp.net immediately. \n Your new temporary password is " + new_password

	    mail(to: @email, subject: 'Impact Password Reset', body: @body)

	    puts "send mail new pass " + new_password
  		#set password here - set if successful	      	
  		response = ChangePasswordService.new(user,new_password).perform
		 if response.success?
		 	puts "success!"
		 else
		 	render_error(:unauthorized, response.errors)
		 end





	  end

	
end
