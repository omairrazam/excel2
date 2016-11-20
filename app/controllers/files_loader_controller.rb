class FilesLoaderController < ApplicationController
	
	def show_loader
	end

	def load_file
		
		uploader = FileUploader.new
		uploader.store!(params[:file])

		RawDatum.load_from_file

		redirect_to root_path
	end
end
