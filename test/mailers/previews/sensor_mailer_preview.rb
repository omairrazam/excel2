# Preview all emails at http://localhost:3000/rails/mailers/sensor_mailer
class SensorMailerPreview < ActionMailer::Preview
  def sample_mail_preview
    SensorMailer.sample_email(User.first)
  end
end
