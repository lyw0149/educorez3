class LoginController < ApplicationController	
  def index
		@show_nav = false
		@ex_url = request.referrer
  end
	def login_complete
		
	end
end
