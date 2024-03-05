class Users::RegistrationsController < Devise::RegistrationsController
  # Override the new method to handle company_name parameter
  def new
    build_resource({})
    self.resource.company_name = params[:company_name] if params[:company_name].present?
    respond_with self.resource
  end

  # Override the create method to assign default role, handle redirection, and create company
  def create
    build_resource(sign_up_params)

    # Assign the default role
    resource.role_id = Role.find_by(role_name: 'super_admin').id

    # Check if company name is provided
    if params[:user][:company_name].present?
      company = Company.create(company_name: params[:user][:company_name])
      resource.company_id = company.id
    end

    resource.save
    yield resource if block_given?

    # Redirect to the signup page if the signup attempt fails
    if resource.errors.any?
      flash[:error] = resource.errors.full_messages.join('. ')
      redirect_to new_user_registration_path
    else
      respond_with resource, location: after_inactive_sign_up_path_for(resource)
    end
  end

  protected

  # Override the redirection paths after signup
  def after_sign_up_path_for(resource)
    new_user_registration_path(resource)
  end

  def after_inactive_sign_up_path_for(resource)
    new_user_registration_path(resource)
  end
end