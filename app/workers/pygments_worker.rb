class PygmentsWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence do
    
    hourly(1)
    # if you want to specify the exactly minute or minutes
    # `minute_of_hour(30, ...)`
    # hourly(2).minute_of_hour(30)
  end

  def perform(id)

    
    users = User.all
    users.each do |user|
      SensorMailer.sample_email(user).deliver
      ########working format
      # directory_name = Rails.root.to_s +  "/excelsheets/#{user.id}"
      # Dir.mkdir(directory_name) unless File.exists?(directory_name)
      # session = GoogleDrive::Session.from_config("config.json")
      
      # user.machines.each do |m|
      #   ws = session.spreadsheet_by_title(m.sheetname).worksheets[0] rescue nil
      #   m.fetch_data_from_excel(ws,user)
      #   m.update_offtimes
      #   m.touch
      # end

      ######## old ###############
      # if user.sheet_name.present?
      #   ws = session.spreadsheet_by_title(user.sheet_name).worksheets[0] rescue nil
      #   user_machines = user.machines

      #   if user_machines.present? and ws.present?
      #     Machine.fetch_data_from_excel(ws, user, user_machines)
      #     user_machines.each do|machine|
      #       #SensorMailer.sample_email(machine).deliver
      #       machine.update_offtimes
      #       machine.touch
      #     end
      #   end

      # end
      ################################

    end
    


  end
end