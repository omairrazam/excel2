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
    PygmentsWorker.perform_async(1)
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
end
