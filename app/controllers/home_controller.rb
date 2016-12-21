class HomeController < BaseController	
    before_action :load_machine, only: [:ajax_info_box_update, :show]

	def ajax_info_box_update

		@machine_decorator = MachineDecorator.new(@current_machine.specific, params[:date])
		
		respond_to do |format|
		  format.html 
		  format.js 
		end
	end

	def show
        PygmentsWorker.perform_async
      
		if @current_machine.blank?
			flash.now[:alert]  = 'Machine not present' 
			#redirect_to root_path and return
		else
			@machine_decorator = MachineDecorator.new(@current_machine.specific, params[:date])
		
			if !@machine_decorator.has_data?
				flash.now[:notice] = 'No Data Found...'
			end

			#update machine
			@current_machine.specific.process

			#debugger

			@hourly_stats = @current_machine.hourly_stats.where('datee=?', params[:date]||Time.now.strftime("%F")).order('hour asc')
		end
	end

	private

	def load_machine
		@current_machine = current_user.machines.find(params[:id]) rescue nil
	end

	def data_params
        params.permit(:datee, :timee, :numbere, :typee)
    end
end
