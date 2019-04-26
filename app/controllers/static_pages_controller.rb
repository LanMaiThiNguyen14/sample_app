class StaticPagesController < ApplicationController
  def home
    return unless logged_in?
    @micropost = current_user.microposts.build
    @feed_items = Micropost.feed(current_user).micropost_desc
                           .paginate(page: params[:page])
  end

  def help; end
end
