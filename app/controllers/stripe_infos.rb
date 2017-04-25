class StripeInfosController < ApplicationController
	def new
		StripeInfo.new
	end

	def create
	  customer = Stripe::Customer.create(
	    :email => params[:stripeEmail],
	    :source  => params[:stripeToken]
	  )
		if current_user.accounts.present?
			@stripe_info = StripeInfo.new customer_id: customer.id, account_id: current_user.accounts.select(:id)
		else
			@account = Account.new user_id: current_user.id
			@account.save
			@stripe_info = StripeInfo.new customer_id: customer.id, account_id: @account.id
		end
		@stripe_info.save
		redirect_to :back
		rescue Stripe::CardError => e
		  flash[:error] = e.message
		  redirect_to new_charge_path
	end

	def add_bank_account
		account = Stripe::Account.retrieve(current_user.accounts.first.stripe_infos.first.stripe_id)
		account.external_accounts.create(:external_account => params[:token_id])
	end

end
