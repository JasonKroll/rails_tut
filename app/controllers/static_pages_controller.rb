class StaticPagesController < ApplicationController
  def home
    @micropost = current_user.microposts.build if signed_in?
    @feed_items = current_user.feed.paginate(page: params[:page], per_page: 5)
  end

  def about
  end

  def help
  end

  def contact
    
  end
end
