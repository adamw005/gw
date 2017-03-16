class ProjectsController < ApplicationController
	before_action :authenticate_user!, only: [:new, :create]

  def show
		@project = Project.find(params[:id])
		@post = @project.posts.build
  end

  def index
		@projects = Project.all.order(created_at: :desc)
  end

	def new
    @project = Project.new
		@project.rewards_tiers.build
		@project.goals.build
  end

  def create
    @project = Project.new project_params
		# If User does not have Stripe account_id, create one
		@account = Account.where(user_id: @project.user.id).first
		unless @account
			# Create a User.Account
			Account.create(user_id: current_user.id)
		end
		unless @account.exists? && StripeInfo.where(account_id: @account.id).first.exists?
			# Create StripeInfo record
			StripeInfo.create(account_id: @account.id)
		end
		unless @account.exists? && StripeInfo.where(account_id: @account.id).first.stripe_id.exists?
			# Create Managed Stripe Account
			stripe_account = Stripe::Account.create(
			  {
			    :country => "US", # TODO Create country field in Project creation form
			    :managed => true
			  }
			)
			stripe_info = StripeInfo.where(account_id: @account.id)
			stripe_info.id = stripe_account.id
			stripe_info.secret_key = stripe_account.keys.secret
			stripe_info.publishable_key = stripe_account.keys.publishable
			stripe_info.save
		end

    if @project.save
      redirect_to projects_path(@project)
    else
      render :action => 'new'
    end
  end

	private

	def project_params
		params.require(:project).permit(:user_id, :title, :format, :charge_occurrence, :body, :box_image, rewards_tiers_attributes: [:min_amount, :body], goals_attributes: [:amount, :body])
	end

end
