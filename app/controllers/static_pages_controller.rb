class StaticPagesController < ApplicationController
  attr_reader :user

  def index
    if logged_in?
      @micropost = current_user.microposts.build
      @feed_items = find_posts.most_recent.paginate page: params[:page],
        per_page: Settings.per_page
    else
      @micropost = Micropost.new
      @feed_items = []
    end
  end

  def show
    if valid_page?
      render "static_pages/#{params[:page]}"
    else
      render file: "public/404.html", status: :not_found
    end
  end

  private

  def find_posts
    following_ids = "SELECT followed_id FROM relationships
        WHERE follower_id = :user_id"
    Micropost.feed following_ids, current_user.id
  end

  def valid_page?
    File.exist?(Pathname.new Rails.root +
      "app/views/static_pages/#{params[:page]}.html.erb")
  end
end
