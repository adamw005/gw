# Rails Console
@user = User.find(13)
@account = Stripe::Account.retrieve(@user.accounts.first.stripe_infos.first.stripe_id)
@stripe_id = @user.accounts.first.stripe_infos.first.stripe_id
@bank_accounts = Stripe::Account.retrieve(@stripe_id).external_accounts.data
@account_balance = Stripe::Balance.retrieve(stripe_account: @account.id)

@user = User.find(13)
@account = Stripe::Account.retrieve(@user.accounts.first.stripe_infos.first.stripe_id)
@payout_list = Stripe::Payout.list({}, {:stripe_account => @account.id})

@payout_list.each do |p|

Stripe::Account.retrieve(@stripe_id).external_accounts.data#[{id: @p.destination}]



@number_charges_accepted = PastTransaction.where(project_id: 127).where(status: 'successful').group_by_month(:created_at, last: 6).count
# @number_charges_accepted = @number_charges_accepted.transform_keys{ |key| key.strftime("%b %Y") }
@number_charges_accepted = @number_charges_accepted.transform_keys.with_index{ |key, i| if i % 2 == 0 then key.strftime("%b %Y") else " "*i end }


stripe_account = Stripe::Account.create(
{
:country => "US",
:managed => true,
}
)
stripe_account.tos_acceptance.date	= Time.now.to_i
stripe_account.tos_acceptance.ip = request.remote_ip

@user = User.last
@account = Stripe::Account.retrieve(@user.accounts.first.stripe_infos.first.stripe_id)


attributes = TransactionQueue.last.attributes
attributes.delete("id")
attributes["type_of"] = attributes["type"]
attributes.delete("type")
PastTransaction.create(attributes.merge({status: 'failed'})) # copy + status field
t.destroy # remove from TransactionQueue
























#
