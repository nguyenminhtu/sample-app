class SessionsController < ApplicationController
  def new; end

  def create
    login_params = params[:session]
    user = User.find_by email: login_params[:email].downcase
    if user && user.authenticate(login_params[:password])
      response_success user
    else
      response_fail
    end
  end

  def destroy
    log_out if logged_in?
    flash[:success] = t "sessions.new.logout"
    redirect_to root_path
  end

  private

  def response_success user
    user.activated? ? user_is_activated(user) : user_not_activated
  end

  def response_fail
    flash.now[:danger] = t "sessions.new.error"
    render :new
  end

  def user_is_activated user
    log_in user
    params[:session][:remember_me] == "1" ? remember(user) : forget(user)
    flash[:success] = t "sessions.new.success"
    redirect_back_or root_path
  end

  def user_not_activated
    flash[:warning] = t "mailer.active.notactive"
    redirect_to root_path
  end
end
