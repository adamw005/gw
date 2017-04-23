class SettingsController < ApplicationController

	def withdraw
		@user = User.find(params[:id])

	end


	def user_params
		params.permit(:user_id)	# Will need to add `account` and `amount` to this
	end


end
