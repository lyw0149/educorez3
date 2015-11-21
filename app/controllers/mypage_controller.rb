class MypageController < ApplicationController
  def profile
		@user = current_user
  end

  def profile_complete
		user = User.find(params[:id])
		user.name = params[:name]
		user.email = params[:email]
		user.address = params[:address]
		user.extra_address = params[:extra_address]
		if !params[:image].nil?
			user.image = params[:image]
		end
		if user.save
			flash[:alert] = "수정되었습니다."
			redirect_to :back
		else
			flash[:alert] = user.errors.values.flatten.join(' ')
			redirect_to :back
		end
  end
end
