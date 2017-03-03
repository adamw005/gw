class RegistrationsController < Devise::RegistrationsController
  def new
    super
  end

  def create
		@user = User.new(params[:user].permit(:email, :username, :password, :password_confirmation))
		if verify_recaptcha(model: @user) && @user.save
		  redirect_to root_path
		else
		  render 'new'
		end
  end

  def update
    super
  end
end
