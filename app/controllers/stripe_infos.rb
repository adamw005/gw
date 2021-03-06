class StripeInfosController < ApplicationController
	protect_from_forgery :except => :stripe_webhooks

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
		account.external_accounts.create(:external_account => params[:stripeToken])
		redirect_to :back
	end

	def remove_bank_account
		account = Stripe::Account.retrieve(current_user.accounts.first.stripe_infos.first.stripe_id)
		account.external_accounts.retrieve(params[:id]).delete()
		redirect_to :back
	end

	def default_bank_account
		account = Stripe::Account.retrieve(current_user.accounts.first.stripe_infos.first.stripe_id)
		bank_account = account.external_accounts.retrieve(params[:id])
		bank_account.default_for_currency = true
		bank_account.save
		redirect_to :back
	end

	def create_payout
		account = Stripe::Account.retrieve(current_user.accounts.first.stripe_infos.first.stripe_id)
		amount = (params[:amount].to_d * 100.0).to_i
		Stripe::Payout.create(
		  {
		    :amount => amount,
		    :currency => "usd",
				:destination => params[:bank_id]
		  },
		  {:stripe_account => account.id}
		)
		redirect_to :back
	end

	def submit_fields_needed
		account = Stripe::Account.retrieve(current_user.accounts.first.stripe_infos.first.stripe_id)

		if params.has_key?(:dob)
			account.legal_entity.dob.year = params[:dob].split('-')[0].strip
			account.legal_entity.dob.month = params[:dob].split('-')[1].strip
			account.legal_entity.dob.day = params[:dob].split('-')[2].strip
		end
		if params.has_key?(:first_name)
			account.legal_entity.first_name = params[:first_name]
		end
		if params.has_key?(:last_name)
			account.legal_entity.last_name = params[:last_name]
		end
		if params.has_key?(:entity_type)
			account.legal_entity.type = params[:entity_type]
		end
		if params.has_key?(:tos) && params[:tos] == 'on'
			account.tos_acceptance.date = Time.now.to_i
			account.tos_acceptance.ip = request.remote_ip # Assumes you're not using a proxy
		end
		if params.has_key?(:address_line)
			account.legal_entity.address.line1 = params[:address_line]
		end
		if params.has_key?(:postal_code)
			account.legal_entity.address.postal_code = params[:postal_code]
		end
		if params.has_key?(:city)
			account.legal_entity.address.city = params[:city]
		end
		if params.has_key?(:state)
			account.legal_entity.address.state = params[:state]
		end
		if params.has_key?(:business_name)
			account.legal_entity.business_name = params[:business_name]
		end
		if params.has_key?(:business_tax_id)
			account.legal_entity.business_tax_id = params[:business_tax_id]
		end
		if params.has_key?(:ssn_last_4)
			account.legal_entity.ssn_last_4 = params[:ssn_last_4]
		end
		if params.has_key?(:personal_id_number)
			account.legal_entity.personal_id_number = params[:personal_id_number]
		end


		account.save
		redirect_to :back
	end

	def stripe_webhooks
		head 200
  	event_json = JSON.parse(request.body.read)
	  # Verify the event by fetching it from Stripe
	  event = Stripe::Event.retrieve(event_json["id"])
	  # Do something with event
	end

end
