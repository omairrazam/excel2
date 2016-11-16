class SensorMailer < ApplicationMailer
	#default to: User.users_with_reports.pluck(:email),
	 default from: "sensordatain@gmail.com"

	def sample_email(user)
      @user  = user
      @date  = Time.zone.now.strftime("%Y-%m-%d")
      @hour  = ((Time.zone.now.strftime("%H")).to_i - 1 ).to_s

      #@date = "2016-11-16"
      #@hour = "17"

      mail(to:@user.email, subject: "#{@user.username.capitalize}'s Machine Updates at #{Time.zone.now} from localmachine", cc: ["omairr.azam@gmail.com","niktrychill@gmail.com"])
    end

end
