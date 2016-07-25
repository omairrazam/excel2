class HomeController < BaseController
    require 'roo'
    require 'google/apis/drive_v2'
    require 'google_drive'
    require 'csv'
	require 'iconv'
	
    before_action :load_machines, only: [:index]

	def index
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
		if @current_machine == nil
			flash[:alert]  = 'Machine not present'
		    return
		else 
			if current_user.sheet_name.present?
				directory_name = Rails.root.to_s +  "/excelsheets"
				Dir.mkdir(directory_name) unless File.exists?(directory_name)
				session = GoogleDrive.saved_session("config.json")
				@current_machine.fetch_data_from_excel(session, current_user.sheet_name, @starting_index, @machines)
			else
				flash[:alert]  = 'Sheet name missing'
				return
			end
		end

		if  !@current_machine.has_data
			flash.now[:notice] = 'No Data Found...'
		    return
		end

		@data_json =     @current_machine.getdata_for_graph
		@data_offtimes = @current_machine.getofftimes_for_graph
		@current_machine.update_offtimes
		
		@filter_date 	= params[:date] || @current_machine.datums.last.datee.strftime("%Y-%m-%d")
		@offtime 		= Offtime.where("date=?", @filter_date).first
		@off_minutes 	= @offtime.try(:minutes)	
		@day_efficiency = @offtime.try(:efficiency) 

		respond_to do |format|
		  format.html 
		  format.js 
		end
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
      params.permit(:datee, :timee, :numbere, :typee)
    end
end
