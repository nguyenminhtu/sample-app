class MicropostsController < ApplicationController
  attr_reader :micropost

  before_action :correct_user, only: :destroy
  before_action :require_logged_in, only: %i(create destroy)

  def create
    @micropost = current_user.microposts.build micropost_params
    if micropost.save
      response_create_success
    else
      response_create_fail
    end
  end

  def destroy
    if micropost.destroy
      flash[:success] = t "microposts.destroy.success"
      redirect_to root_path
    else
      flash.now[:danger] = t "microposts.destroy.fail"
      render "static_pages/home"
    end
  end

  private

  def correct_user
    return if (@micropost = current_user.microposts.find_by id: params[:id])
    flash[:danger] = t "microposts.notfound"
    redirect_to root_path
  end

  def micropost_params
    params.require(:micropost).permit :content, :picture
  end

  def require_logged_in
    return if logged_in?
    store_location
    flash[:danger] = t "authorization.error"
    redirect_to login_path
  end

  def response_create_success
    flash[:success] = t "microposts.new.success"
    redirect_to root_path
  end

  def response_create_fail
    @feed_items = []
    flash.now[:danger] = t "microposts.new.fail"
    render "static_pages/home"
  end
end
