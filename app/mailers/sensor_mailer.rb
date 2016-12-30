class SensorMailer < ApplicationMailer
	#default to: User.users_with_reports.pluck(:email),
	default from: "sensordatain@gmail.com"

	def sample_email(user,date_time)
      @user  = user
      #@date  = Time.zone.now.strftime("%Y-%m-%d").to_s
      #@hour  = ((Time.zone.now.strftime("%H")).to_i - 1 ).to_s

      @date = date_time.strftime("%Y-%m-%d")
      @hour = date_time.strftime("%H")
      
      #@date = "2016-11-27"
      #@hour = "19"

      mail(to:@user.email, subject: "#{@user.username.capitalize}'s Machine Updates at #{date_time}", cc: ["omairr.azam@gmail.com"])
    end

end
