class PasswordResetsController < ApplicationController
  attr_reader :user

  before_action :find_user, :valid_user?,
    :check_expiration, only: %i(edit update)

  def new; end

  def create
    reset_params = params[:password_reset]
    if @user = User.find_by(email: reset_params[:email].downcase)
      response_create_success user
    else
      response_create_fail
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      user.errors.add :password, t("password_resets.update.blank")
      redirect_to edit_password_reset_path
    elsif user.update_attributes user_params
      response_update_success user
    else
      response_update_fail
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def find_user
    return if @user = User.find_by(email: params[:email])
    flash[:danger] = t "password_resets.find.fail"
    redirect_to root_path
  end

  def valid_user?
    redirect_to root_path unless user && user.valid_reset_password?(params[:id])
  end

  def check_expiration
    return unless user.password_reset_expired?
    flash[:danger] = t "password_resets.update.expire"
    redirect_to new_password_reset_path
  end

  def response_create_success user
    user.create_reset_token
    user.send_password_reset_email
    flash[:info] = t "password_resets.send.success"
    redirect_to root_path
  end

  def response_create_fail
    flash.now[:danger] = t "password_resets.send.fail"
    render :new
  end

  def response_update_success user
    log_in user
    user.update_attributes reset_digest: nil
    flash[:success] = t "password_resets.update.success"
    redirect_to user
  end

  def response_update_fail
    render :edit
  end
end
