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
    puts "tracker in start of perform method @#{Time.now}"
    users = User.all
    users.each do |user|
      puts "---------------------------------------------------------------------------------"
      puts "tracker inside async users loop @#{Time.now}"
      puts "---------------------------------------------------------------------------------"
      directory_name = Rails.root.to_s +  "/excelsheets"
      Dir.mkdir(directory_name) unless File.exists?(directory_name)
      session = GoogleDrive::Session.from_config("config.json")

      if user.sheet_name.present?
        ws = session.spreadsheet_by_title(user.sheet_name).worksheets[0] rescue nil
        user_machines = user.machines

        if user_machines.present? and ws.present?
          puts "---------------------------------------------------------------------------------"
           puts "tracker before fetching data from excel @#{Time.now}"
          puts "---------------------------------------------------------------------------------"
          Machine.fetch_data_from_excel(ws, user, user_machines)
          user_machines.each do|machine|
            machine.update_offtimes
            machine.touch
          end
        end

      end
    end
    puts "---------------------------------------------------------------------------------"
     puts "tracker in end of perform method @#{Time.now}"
    puts "---------------------------------------------------------------------------------"
  end
end