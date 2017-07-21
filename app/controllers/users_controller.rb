class UsersController < ApplicationController
  attr_reader :user

  def new
    @user = User.new
  end

  def show
    @user = User.find_by id: params[:id]
  end

  def create
    @user = User.new user_params
    if user.save
      flash[:success] = t "users.new.success"
      redirect_to user
    else
      render :new
    end
  end

  private
  def user_params
    params.require(:user).permit :name, :email,
      :password, :password_confirmation
  end
end
