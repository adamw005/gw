class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

	# saves the location before loading each page so we can return to the
	# right page. If we're on a devise page, we don't want to store that as the
	# place to return to (for example, we don't want to return to the sign in page
	# after signing in), which is what the :unless prevents
	before_filter :store_current_location, :unless => :devise_controller?
	before_action :configure_permitted_parameters, if: :devise_controller?

	private
  # override the devise helper to store the current location so we can
  # redirect to it after loggin in or out. This override makes signing in
  # and signing up work automatically.
  def store_current_location
    store_location_for(:user, request.url)
  end

	protected

  def configure_permitted_parameters
    added_attrs = [:username, :email, :password, :password_confirmation, :remember_me, :country_id]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

end
