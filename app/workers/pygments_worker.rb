class PygmentsWorker
  include Sidekiq::Worker

  def perform(id)
  	# u = User.find(id)
  	# m = u.machines.build
  	# m.name = "sidekiq test"
  	# m.save!
  		current_user   = User.find(id)
   	    directory_name = Rails.root.to_s +  "/excelsheets"
   	    

		Dir.mkdir(directory_name) unless File.exists?(directory_name)
		session = GoogleDrive.saved_session("config.json")
		ws = session.spreadsheet_by_title(current_user.sheet_name).worksheets[0] rescue nil

		# if ws.blank?
		# 	flash[:alert]  = "Google Sheet of name '#{current_user.sheet_name}' doesn't exist on your drive."
		# 	return
		# end
		machines = current_user.machines
    machines.first.update_offtimes
		machines.first.fetch_data_from_excel(ws, current_user, machines)
  end
end