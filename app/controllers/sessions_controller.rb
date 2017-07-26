class SessionsController < ApplicationController
  def new; end

  def create
    login_params = params[:session]
    user = User.find_by email: login_params[:email].downcase
    if user && user.authenticate(login_params[:password])
      find_success user
    else
      find_fail
    end
  end

  def destroy
    log_out
    flash[:success] = t "sessions.new.logout"
    redirect_to root_path
  end

  private

  def find_success user
    log_in user
    flash[:success] = t "sessions.new.success"
    redirect_to user
  end

  def find_fail
    flash.now[:danger] = t "sessions.new.error"
    render :new
  end
end
