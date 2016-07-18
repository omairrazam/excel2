class RegistrationsController < Devise::RegistrationsController
  protected

  def after_sign_up_path_for(resource)
    m1 = resource.machines.build
    m1.name = "SHEL001"
    m1.save

    m2 = resource.machines.build
    m2.name = "SHEL002"
    m2.save

    m3 = resource.machines.build
    m3.name = "SHEL003"
    m3.save

    m4 = resource.machines.build
    m4.name = "SHEL004"
    m4.save

    m5 = resource.machines.build
    m5.name = "SHEL005"
    m5.save

    root_path 
  end
end