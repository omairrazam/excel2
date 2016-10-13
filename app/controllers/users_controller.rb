class UsersController < ApplicationController
	def login
		if !user_signed_in?
			redirect_to new_user_session_path
		else
			user_machine = current_user.machines.try(:first)
			redirect_to user_machine.present? ? home_path(user_machine.id) : home_path(-1)
		end
	end

	def show
		@resource = current_user
		render :template =>"devise/registrations/edit"
	end
end
