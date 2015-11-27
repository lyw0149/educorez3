class RegistrationsController < Devise::RegistrationsController

  protected
  def update_resource(resource, params)
    resource.update(params.except(:current_password))
  end
end