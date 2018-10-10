class PasswordResetsController < ApplicationController
  before_action :check_valid, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "password.email_sent"
      redirect_to root_url
    else
      flash.now[:danger] = t "password.not_found"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, t("password.password_empty")
      render :edit
    elsif @user.update user_params
      sign_in @user
      @user.update reset_digest: nil
      flash[:success] = t "password.password_reseted"
      redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user)
        .permit :password, :password_confirmation
  end

  def check_valid
    @user = User.find_by email: params[:email]
    # valid_user
    redirect_to root_url unless
        @user && @user.activated && @user.authenticated?(:reset, params[:id])
    # check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t "password.expired_password"
    redirect_to new_password_reset_url
  end
end
