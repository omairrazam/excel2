class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :machines, dependent: :destroy
  validates :sheet_name, :presence => true


  def self.test_method
   

    puts "ssssssssssssssssssssssssssssssssssssssssssssssssssss",Time.now
   #User.create(:email=> "co@bbb.com",:password=> "sfsfsdfsdfsd",:sheet_name=> "sfsdfsdf")
  end

  private    
	def password_required?
  		new_record? ? super : false
	end  
end
