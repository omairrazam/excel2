class HomeController < BaseController
    require 'roo'
    require 'google/apis/drive_v2'
    require 'google_drive'
    require 'csv'
	require 'iconv'
	
    before_action :load_machines, only: [:index, :ajax_info_box_update, :show]
   
	def index
		# @current_machine = @machines.first
		# #PygmentsWorker.perform_in(1.minute,1)
		# #debugger
		# if @current_machine == nil
		# 	flash[:alert]  = 'Machine not present'
		#     return
		# else 
		# 	if current_user.sheet_name.blank?
		# 		flash[:alert]  = 'Sheet name missing'
		# 		return
		# 	end
		# end
		
		# if  !@current_machine.has_data
		# 	flash.now[:notice] = 'No Data Found...'
		#     return
		# end

		# @data_json = @current_machine.getdata_for_graph
		
		# @data_offtimes = @current_machine.getofftimes_for_graph
		
		
		# respond_to do |format|
		#   format.html 
		#   #format.js 
		# end
	end

	def ajax_info_box_update
		
		@current_machine = @machines.where('id=?', params[:machine_id]).first
		@date 	 = params[:date]

		if @current_machine.present? and @date.present?
			@filter_date 	=  @date|| @current_machine.datums.last.datee.strftime("%Y-%m-%d")
			@offtime 		=  @current_machine.offtimes.where("date=?", @filter_date).first
			@off_minutes 	=  @offtime.try(:minutes)	
			@day_efficiency =  @current_machine.efficiency(@filter_date)
		end

		respond_to do |format|
		  format.html 
		  format.js 
		end
	end

	def show

		select_current_machine
		PygmentsWorker.perform_in(1)
		#debugger
		if @current_machine == nil
			flash[:alert]  = 'Machine not present'
		    return
		else 


			if current_user.sheet_name.blank?
				flash[:alert]  = 'Sheet name missing'
				return
			end
		end
		
		if  !@current_machine.has_data
			flash.now[:notice] = 'No Data Found...'
		    return
		end

		@data_json = @current_machine.getdata_for_graph
		
		@data_offtimes = @current_machine.getofftimes_for_graph
		
		#render "/home/index"
	end

	private
	
	def select_current_machine
		if params[:id].present?
			if params[:id].to_i    == 1
				@current_machine = @machines.first
			elsif params[:id].to_i == 2
				@current_machine = @machines.second
			elsif params[:id].to_i == 3
				@current_machine = @machines.third
			elsif params[:id].to_i == 4
				@current_machine = @machines.fourth
			elsif params[:id].to_i == 5
				@current_machine = @machines.fifth
			end
		else
			@current_machine = current_user.machines.first
		end
	end

	def load_machines
		@machines = current_user.machines
		this_user_data = Datum.where(:machine_id  => [@machines.pluck(:id)])

		# @starting_index = this_user_data.count + 1
		# if @starting_index == 1
		# 	@starting_index = 2
		# end
	end

	def data_params
        params.permit(:datee, :timee, :numbere, :typee)
    end
end
