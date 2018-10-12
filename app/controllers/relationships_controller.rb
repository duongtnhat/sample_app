class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find_by id: params[:followed_id]
    show_error unless @user
    current_user.follow @user
    respond_to {|format| format.js}
  end

  def destroy
    @user = Relationship.find_by(id: params[:id]).followed
    show_error unless @user
    current_user.unfollow @user
    respond_to {|format| format.js}
  end

  private

  def show_error
    flash[:danger] = t "signup.user_not_found"
    redirect_to root_url
  end
end
