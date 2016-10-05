class HomeController < BaseController	
    before_action :load_machine, only: [:ajax_info_box_update, :show]

	def ajax_info_box_update

		if @current_machine == nil 
			return
		end

		if @current_machine.user.id != current_user.id
			return
		end

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

		if @current_machine == nil
			flash[:alert]  = 'Machine not present'
		    return
		end

		if @current_machine.user.id != current_user.id
			return
		end

		if !@current_machine.has_data
			flash.now[:notice] = 'No Data Found...'
		    return
		end
			
		@current_machine   = @current_machine.specific
		@machine_decorator = MachineDecorator.new(@current_machine)
		#debugger
		#update machine
		@current_machine.process

		# decorators work	
		
		#@date 	         =  @current_machine.datums.last.datee.strftime("%Y-%m-%d")
		#@offtime 		 =  @current_machine.offtimes_by_date(@date).first
		#@off_minutes 	 =  @offtime.try(:minutes)	
		#@day_efficiency  =  @current_machine.efficiency(@date)

		

		#@data_json       = @current_machine.getdata_for_graph
		#@data_offtimes   = @current_machine.getofftimes_for_graph	
	end

	private

	def load_machine
		@current_machine = Machine.find(params[:id]) rescue nil
	end

	def data_params
        params.permit(:datee, :timee, :numbere, :typee)
    end
end
