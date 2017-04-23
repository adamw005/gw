class SettingsController < ApplicationController

	def withdraw
		@user = user_params

	end


	def user_params
		params.permit(:user_id)	# Will need to add `account` and `amount` to this
	end


end
