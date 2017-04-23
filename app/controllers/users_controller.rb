class UsersController < ApplicationController

	def withdraw
		@user = user_params

	end


	def user_params
		params.require(:user).permit(:user_id)	# Will need to add `account` and `amount` to this
	end


end
