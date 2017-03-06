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
    @subscription = Subscription.new subscription_params
    if @subscription.save
      redirect_to projects_path(@subscription.project.id)
    else
      redirect_to projects_path(@subscription.project.id)
    end
  end

	private

	def subscription_params
		params.require(:subscription).permit(:type, :amount, :project_id, :user_id, :rewards_tier_id)
	end

end
