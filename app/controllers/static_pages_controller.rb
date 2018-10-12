class StaticPagesController < ApplicationController
  def home
    return unless signed_in?
    @micropost = current_user.microposts.build
    @feed_items = current_user.feed
      .page(params[:page])
      .per Settings.constant.user_page_size
  end

  def about; end

  def help; end

  def contact; end
end
