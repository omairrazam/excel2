class HomeController < BaseController
    require 'roo'

	def index
	  # 	Datum.transaction do
	  #   	url = "https://docs.google.com/spreadsheets/d/1Up9U1Y2nY2S2qtd2w64Nzd330R9S1VWRr1n0G9FtfTQ/pub?output=xlsx"
			# xlsx = Roo::Spreadsheet.open(url, extension: :xlsx)
			# sheet = xlsx.sheet(0)
			# header = sheet.row(1)
			# (2..sheet.last_row).each do |i|
		 #        row = Hash[[header,sheet.row(i)].transpose]
			# 	data = Datum.new
			# 	data.date = row["Date"]
			# 	data.time = row["Time"]
			# 	data.number = row["Number"]
			# 	data.type = row["Type"]
			# 	data.save!
	  #       end
	  # 	end
	end

	def data_params
      params.permit(:Date, :Time, :Number, :Type)
    end
end
