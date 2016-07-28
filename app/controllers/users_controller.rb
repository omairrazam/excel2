class UsersController < ApplicationController
	def login
		if !user_signed_in?
			redirect_to new_user_session_path
		else
			redirect_to home_index_path
		end
	end

	def show
		@resource = current_user
		render :template =>"devise/registrations/edit"
	end
end
