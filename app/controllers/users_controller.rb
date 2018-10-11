class UsersController < ApplicationController
  before_action :load_user, except: %i(index new create)
  before_action :logged_in_user, only: %i(index edit update)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: %i(destroy)

  def index
    @users = User.show_user
     .page(params[:page])
     .per(Settings.constant.user_page_size)
  end

  def new
    @user = User.new
  end

  def show
    @microposts = @user.microposts
      .page(params[:page])
      .per(Settings.constant.user_page_size)
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "mail.check_mail"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "user.profile_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if user.destroy
      flash[:success] = t "user.user_deleted"
    else
      flash[:danger] = t "signup.user_not_found"
    end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user)
      .permit :name, :email, :password, :password_confirmation
  end

  def logged_in_user
    return if signed_in?
    store_location
    flash[:danger] = t "user.please_log_in"
    redirect_to signin_path
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to root_url unless current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user.present?
    flash[:danger] = t "signup.user_not_found"
    redirect_to signup_path
  end
end
