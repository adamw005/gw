class SettingsController < ApplicationController

	def withdraw
		@user = User.find(params[:id])
		@account = Stripe::Account.retrieve(current_user.accounts.first.stripe_infos.first.stripe_id)
		@stripe_id = current_user.accounts.first.stripe_infos.first.stripe_id
		@bank_accounts = Stripe::Account.retrieve(@stripe_id).external_accounts.data
		@account_balance = Stripe::Balance.retrieve(stripe_account: @account.id)

		@payout_list = Stripe::Payout.list({}, {:stripe_account => @account.id})

	end


	def user_params
		params.permit(:user_id)	# Will need to add `account` and `amount` to this
	end


end
