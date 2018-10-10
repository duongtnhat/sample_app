class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      if user.activated?
        sign_in user
        params[:session][:remember_me] == "1" ? remember(user) : forget(user)
        redirect_back_or user
      else
        flash[:warning] = t "mail.inactivated_warning"
        redirect_to root_url
      end
    else
      flash[:danger] = t "signin.incorrect_signin"
      redirect_to signin_path
    end
  end

  def destroy
    sign_out if signed_in?
    redirect_to root_url
  end
end
