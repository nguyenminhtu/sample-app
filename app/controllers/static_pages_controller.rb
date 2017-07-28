class StaticPagesController < ApplicationController
  def home
    if logged_in?
      microposts = current_user.microposts
      @micropost = microposts.build
      @feed_items = microposts.most_recent.paginate page: params[:page],
        per_page: Settings.per_page
    else
      @micropost = Micropost.new
      @feed_items = []
    end
  end

  def help; end

  def about; end

  def contact; end
end
