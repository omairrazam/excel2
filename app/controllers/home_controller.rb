class HomeController < BaseController
    require 'roo'
    require 'google/apis/drive_v2'
    require 'google_drive'
    require 'csv'
	require 'iconv'
	
    before_action :load_machines, only: [:index]

	def index

		working_excel
		if params[:machine].present?
			if params[:machine].to_i    == 1
				@current_machine = @machines.first
			elsif params[:machine].to_i == 2
				@current_machine = @machines.second
			elsif params[:machine].to_i == 3
				@current_machine = @machines.third
			elsif params[:machine].to_i == 4
				@current_machine = @machines.fourth
			elsif params[:machine].to_i == 5
				@current_machine = @machines.fifth
			end
		else
			@current_machine = @machines.first
		end
		#debugger
		#working_excel
		if @current_machine == nil
			flash[:notice]  = 'Machine not present'
		    return
		end

		if @current_machine.datums.count <= 0
			flash.now[:notice] = 'No Data Found...'
		    return
		end

		getData
		getOfftimes
		@current_machine.update_offtimes
		#@data_json = Datum.limit(2500)
		
		@filter_date 	= params[:date] || @current_machine.datums.last.Date.strftime("%Y-%m-%d")
		@offtime 		= Offtime.where("date=?", @filter_date).first
		#debugger
		@off_minutes 	= @offtime.try(:minutes)	
		@day_efficiency = @offtime.try(:efficiency) 
		

		#debugger

		#@date = Datum.second.Date
		#@data_json =  Datum.where(Date: @date.midnight..@date.end_of_day).pluck(:Number)
		#@data_json =  Datum.pluck(:Number)
		#d = Datum.first.Time.strftime("%I:%m %p")

		respond_to do |format|
		  format.html 
		  format.js 
		end

		
	end

	def getOfftimes
		@data_offtimes  =  @current_machine.offtimes.select(:date,:minutes).map{|m|
						t = m.date.beginning_of_day.to_time.to_i * 1000
					 	Array.[](t, (1440 - m.minutes)*100/1440)
						}.to_json.to_s.html_safe
	end

	def getData
		#debugger
		 now = @current_machine.datums.first.Timestamp.beginning_of_minute.strftime('%s')
		 now = now.to_i  * 1000
		 
		# now = 1248048000000

		#debugger
		last_time = 0
		@data_json  =  @current_machine.datums.select(:id,:Timestamp,:Number).map{|m|
						#debugger

					 	#now = now + 60000

					 	t = m.Timestamp.strftime('%s').to_i * 1000

					 	
					 	 if t == last_time
					 	 	next
					 	 elsif t < last_time
					 	 	t = last_time + 1 
					 	 end
					 	
					 	last_time = t
					 	
					 	Array.[](t, m.Number)
						}.to_json.to_s.html_safe

		


	end

	def info_box_data
		#@offtime = @current_machine.offtimes.where("date=?", date).first
		#redirect_to root_path
	end



	def process_offTimes

		# save current_date & state
		# loop
			#compare current date
			# if equal

			#for a give date pick first time when it ws off
			# if state = off then add to off_time
			# clear the pointer
			# 

		@off_states = @current_machine.datums.where('state=?',"off")

		# d = Datum.group('date').order('id asc').count('id')
	 	 #debugger
		# d.each_key do |key|
		# 	times = Datum.select('time').where('date=?',key)
		# 	#debugger
		# end
	end

	def working_excel
		directory_name = Rails.root.to_s +  "/excelsheets"
		Dir.mkdir(directory_name) unless File.exists?(directory_name)

	   session = GoogleDrive.saved_session("config.json")
	   ws      = session.spreadsheet_by_title(current_user.sheet_name).worksheets[0]
	  	
	   ws.export_as_file(Rails.root.to_s +  "/excelsheets/#{current_user.sheet_name}.csv")
	   #debugger
	   data_file = Roo::CSV.new(Rails.root.to_s + "/excelsheets/#{current_user.sheet_name}.csv")
	    #debugger

	    if @starting_index >= data_file.last_row
	    	flash.now[:notice] = 'Your Data is upto date'
	    	return
		end

	  	Datum.transaction do
		   # data_file = CSV.read('/Users/Apple/RAILS_PROJECTS/excel2/tmp/tt.csv')
		    header = data_file.row(1)
			  (@starting_index..data_file.last_row).each do |i|
			  	#debugger
			    row = Hash[[header, data_file.row(i)].transpose]

			    d 				= Datum.new
			    d.attributes    = row.to_hash.slice("Time","Date","Number","Type","Timestamp")
			    current_machine = @machines.find{|m|m.name == row["ID"]}
			    d.machine_id    = current_machine.id
			    d.Time 			= d.Time.beginning_of_minute

			    d.Timestamp = row["Date"]+' '+ row["Time"]
			    d.Timestamp = d.Timestamp.beginning_of_minute
			    if d.Number <= 10
			    	d.state = "off"
			    else
			    	d.state = "on"
			    end
			    #debugger
			    d.save!
			  end
		    # columns = [:Number]
		    # Datum.import columns, data_file, validate: false
		end
	  	#arr     = ws.list.to_hash_array

	  # 	Datum.transaction do
	  # 		#debugger
	  # 		(@starting_index..ws.num_rows).each do |row|
	  # 		  # get this row's machine first
	  # 		   if ws[row,4].blank?
	  # 		   	next
	  # 		   end

	  # 		  current_machine = @machines.find{|m|m.name == ws[row, 4]}
	  # 		  #debugger
	  # 		  data        = current_machine.datums.build
	  # 		  data.date   = ws[row,2]
			#   data.time   = ws[row,3]
			#   data.number = ws[row,5]
			#   data.typ    = ws[row,6]
			#   data.save!
			  
			# end




		 #  # 	ws.list.each do |row|
		 #  # 		#find this rows machine first

		 #  # 		data        = Datum.new
			# 	# data.date   = row["Date"]
			# 	# data.time   = row["Time"]
			# 	# data.number = row["Number"]
			# 	# data.typ    = row["Type"]
			# 	# data.save!
		 #  # 	end
	  # 	end
	end

	def old_Excel
		Datum.transaction do
	    	url    = "https://docs.google.com/spreadsheets/d/1Up9U1Y2nY2S2qtd2w64Nzd330R9S1VWRr1n0G9FtfTQ/pub?output=xlsx"
			xlsx   = Roo::Spreadsheet.open(ws.worksheet_feed_url, extension: :xlsx)
			sheet  = xlsx.sheet(0)
			header = sheet.row(1)

			(@starting_index..sheet.last_row).each do |i|
		        row       = Hash[[header,sheet.row(i)].transpose]
				data      = Datum.new
				data.date = row["Date"]
				data.time   = row["Time"]
				data.number = row["Number"]
				data.type   = row["Type"]
				data.save!
	        end
	  	end
	end

	def redirect
		client = Signet::OAuth2::Client.new({
		client_id: "163291962220-k8lklph6pk73tjlc00fm3muhdjilevet.apps.googleusercontent.com",
		client_secret: "X1h_8ApMqymF60tGfGLnP-wj",
		authorization_uri: 'https://accounts.google.com/o/oauth2/auth',
		scope: [
		     "https://www.googleapis.com/auth/drive",
		     "https://spreadsheets.google.com/feeds/",
		   ],
		redirect_uri: "http://edb90cc6.ngrok.io/redirect"
		})

		redirect_to client.authorization_uri.to_s
	end

	def callback
		client = Signet::OAuth2::Client.new({
		client_id: "163291962220-k8lklph6pk73tjlc00fm3muhdjilevet.apps.googleusercontent.com",
		client_secret: "X1h_8ApMqymF60tGfGLnP-wj",
		token_credential_uri: 'https://accounts.google.com/o/oauth2/token',
		authorization_uri: "https://accounts.google.com/o/oauth2/auth",
		redirect_uri: "http://edb90cc6.ngrok.io/redirect",
		code: params[:code]
		})

		response = client.fetch_access_token!
		#debugger
		client.client_secret = nil
		session[:access_token] = response['access_token']
		#debugger
		redirect_to calenders_path
	end

	def calender
		access_token = AccessToken.new session[:access_token]
		client = Signet::OAuth2::Client.new(access_token: session[:access_token],
			authorization_uri: "https://accounts.google.com/o/oauth2/auth")
	  	#drive = Google::Apis::DriveV2::DriveService.new
		drive = Google::Apis::DriveV3::DriveService.new
		drive.authorization = client
		#drive.authentication = access_token
		#debugger
		files = drive.list_files
	  
	  # service = Google::Apis::CalendarV3::CalendarService.new

	  # service.authorization = client
	  # debugger
	  # @calendar_list = service.list_calendar_lists

	end

	private
	
	def load_machines
		@machines = current_user.machines
		this_user_data = Datum.where(:machine_id  => [@machines.pluck(:id)])
		@starting_index = this_user_data.count + 1
		if @starting_index == 1
			@starting_index = 2
		end
		

	end

	def data_params
      params.permit(:Date, :Time, :Number, :Type)
    end
end
