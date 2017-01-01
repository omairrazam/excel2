class PygmentsWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence do
    hourly(1)
    #minutely(2)
    # if you want to specify the exactly minute or minutes
    # `minute_of_hour(30, ...)`
    # hourly(2).minute_of_hour(30)
  end

  def perform(last_occurrence, current_occurrence)
    
    current_date_time = DateTime.strptime(current_occurrence.to_s,'%s')
    #u = User.find_by_email("niktrychill@gmail.com")

    #SensorMailer.sample_email(u).deliver

    users_with_reports = User.users_with_reports.count
    if users_with_reports > 0
      users = User.all
      users.each do |user|
        if user.machines.count > 0
            SensorMailer.sample_email(user,current_date_time).deliver
        end
      end
    end
  end
end