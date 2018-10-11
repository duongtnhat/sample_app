class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  def logged_in_user
    return if signed_in?
    store_location
    flash[:danger] = t "user.please_log_in"
    redirect_to signin_path
  end
end
