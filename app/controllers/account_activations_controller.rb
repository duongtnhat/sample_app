class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      sign_in user
      flash[:success] = t "mail.activated"
      redirect_to user
    else
      flash[:danger] = t "mail.inactivated"
      redirect_to root_url
    end
  end
end
