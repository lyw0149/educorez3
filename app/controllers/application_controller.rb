class ApplicationController < ActionController::Base
	def authority_forbidden(error)
  Authority.logger.warn(error.message)
  redirect_to request.referrer.presence || root_path, :alert => 'You are not authorized to complete that action.'
end
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
	def ensure_signup_complete
    # Ensure we don't go into an infinite loop
    return if action_name == 'finish_signup'

    # Redirect to the 'finish_signup' page if the user
    # email hasn't been verified yet
    if current_user && !current_user.email_verified?
      redirect_to finish_signup_path(current_user)
    end
  end
end
