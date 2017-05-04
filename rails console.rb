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




###     Add Fake Users     ###
100.times do
# Create user
username = Faker::Name.unique.first_name
email = Faker::Internet.unique.email
user = User.new({:email => email, :username => username, :password => 'password', :password_confirmation => 'password', :country_id => 26, :tos => true })
user.skip_confirmation!
user.save!

# Add Stripe account and test card
token = Stripe::Token.create(
:card => {
:number => "4242424242424242",
:exp_month => 5,
:exp_year => 2018,
:cvc => "314"
},
)
current_user = user
customer = Stripe::Customer.create(
:email => email,
:source  => token.id
)
@account = Account.new user_id: current_user.id
@account.save
@stripe_info = StripeInfo.new customer_id: customer.id, account_id: @account.id
@stripe_info.save

# Users subscribe to some current projects
Project.all.each do |proj|
if rand(100) > 75
# tier = proj.rewards_tiers.order("random()").first
tier = proj.rewards_tiers.order("min_amount asc").first
amount = tier.min_amount.to_i
if proj.charge_occurrence = "ReleaseSubscription"
	ReleaseSubscription.create({amount: amount, project_id: proj.id, user_id: user.id, rewards_tier_id: tier.id})
else
	MonthlySubscription.create({amount: amount, project_id: proj.id, user_id: user.id, rewards_tier_id: tier.id})
end

end
end

# Users comment on some subscribed projects
user.subscriptions.each do |sub|
if rand(100) > 90
project_id = sub.project.id
if rand(100) > 50
body = Faker::Hipster.paragraph(3)
else
body = Faker::Hacker.say_something_smart
end
Comment.create({user_id: user.id, project_id: project_id, body: body})
end
end
end









#
