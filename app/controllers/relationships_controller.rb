class RelationshipsController < ApplicationController
  attr_reader :user, :new_relation, :del_relation

  before_action :find_user, only: %i(index)
  before_action :require_logged_in, only: %i(create destroy)

  def index
    action = request.fullpath.split("/").last.split("?").first
    if action.eql? "following"
      @title = t "following.title"
      following
    else
      @title = t "follower.title"
      followers
    end
  end

  def create
    @user = User.find_by id: params[:followed_id]
    current_user.follow user
    response_create_success user
  end

  def destroy
    @user = Relationship.find_by(id: params[:id]).followed
    current_user.unfollow user
    response_destroy_success user
  end

  private

  def find_user
    return if (@user = User.find_by id: params[:id])
    flash[:danger] = t "users.find.fail"
    redirect_to users_path
  end

  def require_logged_in
    return if logged_in?
    store_location
    flash[:danger] = t "authorization.error"
    redirect_to login_path
  end

  def response_create_success user
    respond_to do |format|
      format.html{redirect_to user}
      format.js
    end
  end

  def response_destroy_success user
    respond_to do |format|
      format.html{redirect_to user}
      format.js
    end
  end

  def following
    @users = user.following.paginate page: params[:page],
      per_page: Settings.per_page
  end

  def followers
    @users = user.followers.paginate page: params[:page],
      per_page: Settings.per_page
  end
end
