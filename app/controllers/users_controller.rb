class UsersController < ApplicationController
  attr_reader :user

  before_action :find_user, except: %i(index new create)
  before_action :require_logged_in, except: %i(new create)
  before_action :require_same_user, only: %i(edit update)
  before_action :require_admin, only: :destroy

  def index
    @users = User.active.most_recent.paginate page: params[:page],
      per_page: Settings.per_page
  end

  def new
    @user = User.new
  end

  def show
    @microposts = user.microposts.paginate page: params[:page],
      per_page: Settings.per_page
  end

  def create
    @user = User.new user_params
    if user.save
      response_create_success user
    else
      render :new
    end
  end

  def edit; end

  def update
    if user.update_attributes user_params
      flash[:success] = t "users.edit.success"
      redirect_to user
    else
      render :edit
    end
  end

  def destroy
    if user.destroy
      flash[:success] = t "users.index.destroy"
      redirect_to users_path
    else
      flash[:danger] = t "users.index.fail"
      redirect_to root_path
    end
  end

  private

  def find_user
    return if (@user = User.active.find_by id: params[:id])
    flash[:danger] = t "users.find.fail"
    redirect_to users_path
  end

  def user_params
    params.require(:user).permit :name,
      :email, :password, :password_confirmation
  end

  def require_logged_in
    return if logged_in?
    store_location
    flash[:danger] = t "authorization.error"
    redirect_to login_path
  end

  def require_same_user
    return if user.eql? current_user
    flash[:danger] = t "authorization.fake"
    redirect_to root_path
  end

  def require_admin
    return if current_user.admin?
    flash[:danger] = t "admin.fail"
    redirect_to login_path
  end

  def response_create_success user
    user.send_active_mail
    flash[:info] = t "mailer.success"
    redirect_to root_path
  end
end
