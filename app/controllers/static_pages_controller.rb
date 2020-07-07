class StaticPagesController < ApplicationController
  def home
    @micropost = current_user.microposts.build if signed_in?
    @feed_items = current_user.feed.paginate(page: params[:page], per_page: 15) if signed_in?
    session[:url_home] = request.url
    session.delete(:url_show)
  end

  def help
  end

  def about
  end

  def contact
  end
end
