class ProjectsController < ApplicationController
	before_action :authenticate_user!, only: [:new, :create]

  def show
		if params[:id]
			@project = Project.find(params[:id])
		else
			@project = Project.find_by(slug: params[:slug])
		end
		@post = @project.posts.build
  end

  def index
		if params[:search]
			@projects = Project.search(params[:search]).order("created_at DESC").paginate(:page => params[:page], :per_page => 5)
		else
			@projects = Project.all.order(created_at: :desc).paginate(:page => params[:page], :per_page => 5)
		end
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
			@account = Account.where(user_id: @project.user.id).first
		end
		unless @account && StripeInfo.where(account_id: @account.id).first
			# Create StripeInfo record
			StripeInfo.create(account_id: @account.id)
		end
		unless @account && StripeInfo.where(account_id: @account.id).first.stripe_id
			# Create Managed Stripe Account
			stripe_account = Stripe::Account.create(
			  {
			    :country => @project.user.country.code, #"US",
			    :managed => true
			  }
			)
			# Accept TOS (accepted on sign_up)
			stripe_account.tos_acceptance.date	= Time.now.to_i
			stripe_account.tos_acceptance.ip = request.remote_ip
			
			stripe_info = StripeInfo.where(account_id: @account.id).first
			stripe_info.stripe_id = stripe_account.id
			stripe_info.secret_key = stripe_account.keys.secret
			stripe_info.publishable_key = stripe_account.keys.publishable
			stripe_info.save
		end

    if @project.save
      redirect_to projects_path(@project)#, notice: "Project succesfully created"
    else
      render :action => 'new'
    end
  end

	def dashboard
		@project = Project.find(params[:id])
		@account = Account.where(user_id: @project.user.id).first

		# Create variables to use as data in Dashboard charts
		@earnings_over_time = PastTransaction.where(project_id: @project.id).group_by_month(:created_at, last: 6).sum(:amount)
		@subscriptions_over_time = PastTransaction.where(project_id: @project.id).group_by_month(:created_at, last: 6).count
		@posts_over_time = Post.where(project_id: @project.id).group_by_month(:created_at, last: 6).count
		@comments_over_time = Comment.where(project_id: @project.id).group_by_month(:created_at, last: 6).count
		@number_charges_declined = PastTransaction.where(project_id: @project.id).where(status: 'failed').group_by_month(:created_at, last: 6).count
		@number_charges_accepted = PastTransaction.where(project_id: @project.id).where(status: 'successful').group_by_month(:created_at, last: 6).count
		# Format dates for column_chart
		@number_charges_declined = @number_charges_declined.transform_keys.with_index{ |key, i| if i % 2 == 0 then key.strftime("%b %Y") else " "*i end }
		@number_charges_accepted = @number_charges_accepted.transform_keys.with_index{ |key, i| if i % 2 == 0 then key.strftime("%b %Y") else " "*i end }

		# @amount_charges_declined = PastTransaction.where(project_id: @project.id).where(status: 'failed').group_by_month(:created_at, last: 6).sum(:amount)
		# @amount_charges_accepted = PastTransaction.where(project_id: @project.id).where(status: 'successful').group_by_month(:created_at, last: 6).sum(:amount)

		# Find Stripe account balance
		@account_balance = Stripe::Balance.retrieve(stripe_account: StripeInfo.where(account_id: @account.id).first.stripe_id)

	end

	private

	def project_params
		params.require(:project).permit(:user_id, :title, :format, :charge_occurrence, :body, :box_image, rewards_tiers_attributes: [:min_amount, :body], goals_attributes: [:amount, :body])
	end

end
