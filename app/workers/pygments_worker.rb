class PygmentsWorker
  include Sidekiq::Worker

  def perform(id)
  	User.create(:email => "sidekiq@test.com")
  # 		directory_name = Rails.root.to_s +  "/excelsheets"
		# Dir.mkdir(directory_name) unless File.exists?(directory_name)
		# session = GoogleDrive.saved_session("config.json")
		# ws = session.spreadsheet_by_title(current_user.sheet_name).worksheets[0] rescue nil

		# if ws.blank?
		# 	flash[:alert]  = "Google Sheet of name '#{current_user.sheet_name}' doesn't exist on your drive."
		# 	return
		# end
		# machines = current_user.machines
		# @current_machine.fetch_data_from_excel(ws, current_user, machines)
  end
end