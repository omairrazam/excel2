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
      directory_name = Rails.root.to_s +  "/excelsheets"
      Dir.mkdir(directory_name) unless File.exists?(directory_name)
      session = GoogleDrive::Session.from_config("config.json")

      if user.sheet_name.present?
        ws = session.spreadsheet_by_title(user.sheet_name).worksheets[0] rescue nil
        user_machines = user.machines

        if user_machines.present? and ws.present?
          Machine.fetch_data_from_excel(ws, user, user_machines)
          user_machines.each do|machine|
            machine.update_offtimes
            machine.touch
          end
        end

      end

    end
  end
end