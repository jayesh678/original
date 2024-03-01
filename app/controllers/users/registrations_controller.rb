class Users::RegistrationsController < Devise::RegistrationsController

  def create
    super do |resource|
      resource.role_id = Role.find_by(role_name: 'super_admin').id
      resource.save
    end
  end
end
