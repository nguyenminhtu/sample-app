class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if user && user.valid_active_account?(params[:id])
      response_success user
    else
      response_fail
    end
  end

  private

  def response_success user
    user.active_user
    log_in user
    flash[:success] = t "mailer.active.success"
    redirect_to users_path
  end

  def response_fail
    flash[:danger] = t "mailer.active.fail"
    redirect_to root_path
  end
end
