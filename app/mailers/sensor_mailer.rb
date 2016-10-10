class SensorMailer < ApplicationMailer
	default to: User.users_with_reports.pluck(:email),
	         from: "sensordatain@gmail.com"

	def sample_email(user)
      @user  = user
      @date  = Time.now.strftime("%m/%d/%Y")
      
      mail( subject: "#{@user.username.capitalize}'s Machine Updates at #{Time.now}")
    end

end
