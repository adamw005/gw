class RegistrationsController < Devise::RegistrationsController
  def new
    super
  end

  def create
		@user = User.new(params[:user].permit(:name))
		if verify_recaptcha(model: @user) && @user.save
		  redirect_to @user
		else
		  render 'new'
		end
  end

  def update
    super
  end
end
