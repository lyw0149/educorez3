class ApplicationController < ActionController::Base
	before_filter :configure_permitted_parameters, if: :devise_controller?
	before_action :show_nav
	
	def login_check
		if current_user.nil?
			redirect_to new_user_session_path
		end
	end

	def show_nav
		@show_nav = true
	end

	def authority_forbidden(error)
		Authority.logger.warn(error.message)
		redirect_to request.referrer.presence || root_path, :alert => 'You are not authorized to complete that action.'
	end
	# Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
 	# protect_from_forgery with: :exception
	def ensure_signup_complete
    # Ensure we don't go into an infinite loop
    return if action_name == 'finish_signup'

    # Redirect to the 'finish_signup' page if the user
    # email hasn't been verified yet
    if current_user && !current_user.email_verified?
      redirect_to finish_signup_path(current_user)
    end
  end
	
	private

	def configure_permitted_parameters
		 devise_parameter_sanitizer.for(:account_update){ |u| u.permit(:name, :image, :email, :password, :password_confirmation) }          
	end
end
