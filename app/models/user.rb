class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :machines
  after_create :create_machines
  validates :sheet_name, :presence => true

  def create_machines
    create_machine("SHEL001")
    create_machine("SHEL002")
    create_machine("SHEL003")
    create_machine("SHEL004")
    create_machine("SHEL005")
    #PygmentsWorker.perform_async(1)
    update
  end

  private    
	def password_required?
  		new_record? ? super : false
	end 

  def create_machine(machine_name)   
    m1 = self.machines.build
    m1.name = machine_name
    m1.save
  end 

  def update
    users = User.all
    users.each do |user|
      directory_name = Rails.root.to_s +  "/excelsheets"
      Dir.mkdir(directory_name) unless File.exists?(directory_name)
      session = GoogleDrive::Session.from_config("config.json")

      if user.sheet_name.present?
        ws = session.spreadsheet_by_title(user.sheet_name).worksheets[0] rescue nil
        user_machines = user.machines

        if user_machines.present? and ws.present?
          Machine.fetch_data_from_excel(ws, user, user_machines)
          user_machines.each do|machine|
            machine.update_offtimes
            machine.touch
          end
        end

      end

    end
  end
end
