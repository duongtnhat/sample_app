class UsersController < ApplicationController
  before_action :load_user, except: %i(index new create)
  before_action :logged_in_user, only: %i(index edit update)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: %i(destroy)

  def index
    @users = User.show_user
     .page(params[:page])
     .per Settings.constant.user_page_size
  end

  def new
    @user = User.new
  end

  def show
    @microposts = @user.microposts
      .page(params[:page])
      .per Settings.constant.user_page_size
    if current_user.following? @user
      @relationships = current_user.active_relationships.find_by followed_id: @user.id
    else
      @relationships = current_user.active_relationships.build
    end
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

  def following
    @title = t "follow.following"
    @users = @user.following.page(params[:page])
      .per Settings.constant.user_page_size
    render "show_follow"
  end

  def followers
    @title = t "follow.followers"
    @users = @user.followers.page(params[:page])
      .per Settings.constant.user_page_size
    render "show_follow"
  end

  private

  def user_params
    params.require(:user)
      .permit :name, :email, :password, :password_confirmation
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
