class UsersController < ApplicationController

	def withdraw


	end


	def user_params
		params.require(:user)	# Will need to add `account` and `amount` to this
	end


end
