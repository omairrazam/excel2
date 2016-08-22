class SensorMailer < ApplicationMailer
	default to: Array["sensordatain@gmail.com","omairr.azam@gmail.com"],
	         from: "sensordatain@gmail.com"

	def sample_email(user)
      #@user = user
      mail( subject: 'Sample Email')
    end

end
