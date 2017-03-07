class SubscriptionsController < ApplicationController
	before_action :authenticate_user!, only: [:new, :create]

  def show
		# @subscription = Subscription.find(params[:id])
  end

  def index
		# @subscriptions = Subscription.all.order(created_at: :desc)
  end

	def new
    @subscription = Subscription.new
  end

  def create
		if subscription_params[:amount].to_i >= RewardsTier.find(subscription_params[:rewards_tier_id]).min_amount.to_i
	    @subscription = Subscription.new subscription_params
	    if @subscription.save
	      redirect_to projects_path(@subscription.project.id)
	    else
				# If it doesn't save, it's probably because use can only subscribe to project-rewards_tier once [	validates_uniqueness_of :user_id, scope: :rewards_tier_id ] in subscription.rb
	      redirect_to projects_path(@subscription.project.id)
	    end
		else
			# Amount entered was probably less than chosen tier
			redirect_to projects_path(subscription_params[:project_id])
		end
  end

	private

	def subscription_params
		params.require(:subscription).permit(:type, :amount, :project_id, :user_id, :rewards_tier_id)
	end

end
