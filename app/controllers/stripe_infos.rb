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
			@stripe_info = StripeInfo.new customer_id: customer.id, account_id: @account.id
		end
		@stripe_info.save
		redirect_to :back
		rescue Stripe::CardError => e
		  flash[:error] = e.message
		  redirect_to new_charge_path
	end

end
