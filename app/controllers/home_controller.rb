class HomeController < BaseController	
    before_action :load_machine, only: [:ajax_info_box_update, :show]

	def ajax_info_box_update

		if @current_machine == nil 
			return
		end

		if @current_machine.user.id != current_user.id
			return
		end

		@machine_decorator = MachineDecorator.new(@current_machine.specific, params[:date])
		
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
			
		@machine_decorator = MachineDecorator.new(@current_machine.specific)
		
		#update machine
		#@current_machine.process

		
	end

	private

	def load_machine
		@current_machine = Machine.find(params[:id]) rescue nil
	end

	def data_params
        params.permit(:datee, :timee, :numbere, :typee)
    end
end
